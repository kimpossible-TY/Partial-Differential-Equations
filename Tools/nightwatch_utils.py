import time
import sys
import re
import json
import urllib.request

try:
    import tiktoken
except ImportError:
    tiktoken = None

class RateLimitWatchdog:
    def __init__(self, tpm_limit=4_000_000, rpm_limit=300, max_budget=10_000_000):
        self.tpm_limit = tpm_limit
        self.rpm_limit = rpm_limit
        self.max_budget = max_budget
        
        self.total_tokens_used = 0
        self.minute_start = time.time()
        self.requests_this_minute = 0
        self.tokens_this_minute = 0
        if tiktoken:
            try:
                self.tokenizer = tiktoken.get_encoding("cl100k_base")
            except Exception:
                self.tokenizer = None
        else:
            self.tokenizer = None

    def estimate_tokens(self, text: str) -> int:
        if self.tokenizer:
            return len(self.tokenizer.encode(text))
        return len(text) // 4  # Fallback approximation

    def check_and_throttle(self, estimated_task_tokens: int):
        now = time.time()
        if now - self.minute_start > 60:
            self.minute_start = now
            self.requests_this_minute = 0
            self.tokens_this_minute = 0

        # Halt if we exceed the global session budget
        if self.total_tokens_used + estimated_task_tokens > self.max_budget:
            print(f"🚨 Watchdog Alert: Task exceeds global budget ({self.max_budget} tokens). Halting execution.")
            sys.exit(1)

        # Adaptive Throttling: Check 80% threshold
        if (self.requests_this_minute >= self.rpm_limit * 0.8) or \
           (self.tokens_this_minute + estimated_task_tokens >= self.tpm_limit * 0.8):
            sleep_time = max(0, 60 - (now - self.minute_start)) + 2
            print(f"⚠️ [Throttling] Approaching 80% of RPM/TPM limit. Delaying execution by {sleep_time:.1f}s...")
            time.sleep(sleep_time)
            
            # Reset minute trackers after sleep
            self.minute_start = time.time()
            self.requests_this_minute = 0
            self.tokens_this_minute = 0

        self.requests_this_minute += 1
        self.tokens_this_minute += estimated_task_tokens
        self.total_tokens_used += estimated_task_tokens

def prune_context_via_lite(task_body: str, api_key: str, threshold: int = 30000) -> str:
    # 텍스트가 임계치보다 작으면 원본을 그대로 유지
    if len(task_body) < threshold:
        return task_body
        
    print("✂️ [Pruning] 컨텍스트가 너무 방대합니다. Gemini Flash Lite를 사용하여 핵심 구조만 압축합니다...")
    # OpenClaw 설정의 LITE 모델과 통일
    url = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-3.1-flash-lite-preview:generateContent?key={api_key}"
    
    # 너무 큰 텍스트로 압축기 자체가 터지는 것을 막기 위해 최대 10만 자로 자름
    safe_body = task_body[:100000]
    prompt = (
        "You are an expert context optimizer. Summarize the following project context, logs, or file contents. "
        "Keep all essential code structures, file paths, and error messages, but remove redundant logs, "
        "whitespace, and irrelevant comments to minimize token usage for the next agent.\n\n"
        f"{safe_body}"
    )

    data = {
        "contents": [{"parts": [{"text": prompt}]}]
    }
    
    req = urllib.request.Request(
        url, 
        data=json.dumps(data).encode('utf-8'), 
        headers={'Content-Type': 'application/json'}
    )
    
    try:
        with urllib.request.urlopen(req) as response:
            result = json.loads(response.read().decode())
            pruned_text = result['candidates'][0]['content']['parts'][0]['text']
            print(f"✅ [Pruning] 압축 완료: 원본 {len(task_body)}자 -> 압축 {len(pruned_text)}자")
            return pruned_text
    except Exception as e:
        print(f"⚠️ [Pruning] 압축 실패. 정규식을 통한 강제 공백 제거로 대체합니다: {e}")
        # API 호출 실패 시 무식하지만 확실한 정규식 압축 (빈 줄 및 연속된 공백 제거)
        return re.sub(r'\n\s*\n', '\n', task_body)

def route_model_by_context(tag: str, task_body: str, estimated_tokens: int) -> str:
    if estimated_tokens > 30_000 and tag == "PRO":
        print("📉 [Router] Massive context detected (>30k tokens). Downgrading PRO to FLASH to preserve budget.")
        return "FLASH"
    if estimated_tokens > 100_000:
        print("✂️ [Router] Context exceeds 100k tokens. Forcing LITE and truncating body...")
        return "LITE"
    return tag
