"""
NightWatch Utilities Module

This module provides essential utility functions for managing API usage, token budgets, 
and context optimization. It serves as the primary safeguard to prevent excessive 
API costs and rate limiting during automated agent executions.

Key features:
    - RateLimitWatchdog: Manages RPM/TPM limits and global budget tracking.
    - Context Pruning: Reduces token count by compressing large task bodies.
    - Dynamic Routing: Automatically switches models based on token load.
"""

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
    """
    Manages API request throttling and global token budget tracking.

    Attributes:
        tpm_limit (int): Tokens Per Minute limit (default: 4,000,000).
        rpm_limit (int): Requests Per Minute limit (default: 300).
        max_budget (int): Global token budget allowed per execution (default: 10,000,000).
    """

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
        """
        Estimates the token count of a given text string.
        
        Args:
            text (str): The input text to measure.
        
        Returns:
            int: Estimated token count (uses tiktoken if available, fallback otherwise).
        """
        if self.tokenizer:
            return len(self.tokenizer.encode(text))
        return len(text) // 4  # Fallback approximation: 1 token ~= 4 chars

    def check_and_throttle(self, estimated_task_tokens: int):
        """
        Monitors API limits and throttles execution if approaching defined thresholds.
        
        Logic:
            - Resets metrics if current minute passes.
            - Halts completely if total_tokens_used exceeds max_budget.
            - Throttles execution if RPM or TPM usage exceeds 80% of configured limits.
            - Sleeps until the minute resets + buffer to avoid quota bans.
        """
        now = time.time()
        if now - self.minute_start > 60:
            self.minute_start = now
            self.requests_this_minute = 0
            self.tokens_this_minute = 0

        # Halt if we exceed the global session budget
        if self.total_tokens_used + estimated_task_tokens > self.max_budget:
            print(f"🚨 Watchdog Alert: Task exceeds global budget ({self.max_budget} tokens). Halting execution.")
            sys.exit(1)

        # Adaptive Throttling: Check 80% threshold of limits
        # Using 80% provides a safety buffer against bursts.
        if (self.requests_this_minute >= self.rpm_limit * 0.8) or \
           (self.tokens_this_minute + estimated_task_tokens >= self.tpm_limit * 0.8):
            sleep_time = max(0, 60 - (now - self.minute_start)) + 2
            print(f"⚠️ [Throttling] Approaching 80% of RPM/TPM limit. Delaying execution by {sleep_time:.1f}s...")
            time.sleep(sleep_time)
            
            # Reset minute trackers after sleep to refresh limits
            self.minute_start = time.time()
            self.requests_this_minute = 0
            self.tokens_this_minute = 0

        self.requests_this_minute += 1
        self.tokens_this_minute += estimated_task_tokens
        self.total_tokens_used += estimated_task_tokens

def prune_context_via_lite(task_body: str, api_key: str, threshold: int = 30000) -> str:
    """
    Compresses large task contexts using Gemini Flash Lite if they exceed the size threshold.
    
    Args:
        task_body (str): The raw task content.
        api_key (str): Gemini API key for pruning requests.
        threshold (int): Minimum size (in characters) before pruning is triggered.
    
    Returns:
        str: Compressed or original task body.
    """
    if len(task_body) < threshold:
        return task_body
        
    print("✂️ [Pruning] 컨텍스트가 너무 방대합니다. Gemini Flash Lite를 사용하여 핵심 구조만 압축합니다...")
    # OpenClaw configuration: Uses Lite model to summarize context efficiently
    url = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-3.1-flash-lite-preview:generateContent?key={api_key}"
    
    # Cap text at 100k to prevent the summarizer itself from hitting model constraints
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
        # Fallback regex-based pruning
        return re.sub(r'\n\s*\n', '\n', task_body)

def route_model_by_context(tag: str, task_body: str, estimated_tokens: int) -> str:
    """
    Dynamically downgrades models based on token consumption to preserve budget.
    
    Args:
        tag (str): The requested model tag (PRO/FLASH).
        task_body (str): The task body.
        estimated_tokens (int): The calculated token size.
        
    Returns:
        str: The final model tag to use.
    """
    # If massive context is detected, downgrade PRO to FLASH to preserve budget
    if estimated_tokens > 30_000 and tag == "PRO":
        print("📉 [Router] Massive context detected (>30k tokens). Downgrading PRO to FLASH to preserve budget.")
        return "FLASH"
    # If context is extreme, force LITE
    if estimated_tokens > 100_000:
        print("✂️ [Router] Context exceeds 100k tokens. Forcing LITE and truncating body...")
        return "LITE"
    return tag
