import time
import json
import os
import fcntl
from pathlib import Path

class BudgetWatchdog:
    def __init__(self, limit_tpm=80000, limit_rpm=1000):
        self.limit_tpm = limit_tpm
        self.limit_rpm = limit_rpm
        self.usage_file = Path("/workspace/.usage_metrics.json")
        
        # 파일이 없으면 초기화
        if not self.usage_file.exists():
            self._write_metrics({"window_start": time.time(), "tokens": 0, "requests": 0})

    def _read_metrics(self):
        """파일 락을 사용하여 안전하게 메트릭을 읽어옵니다."""
        try:
            with open(self.usage_file, 'r') as f:
                # 공유 잠금(Shared Lock): 다른 읽기는 허용하되 쓰기는 차단
                fcntl.flock(f, fcntl.LOCK_SH)
                data = json.load(f)
                fcntl.flock(f, fcntl.LOCK_UN)
                return data
        except (FileNotFoundError, json.JSONDecodeError):
            # 파일이 깨졌거나 없으면 초기화된 상태 반환
            return {"window_start": time.time(), "tokens": 0, "requests": 0}

    def _write_metrics(self, data):
        """파일 락을 사용하여 무결성을 유지하며 메트릭을 씁니다."""
        with open(self.usage_file, 'w') as f:
            # 배타적 잠금(Exclusive Lock): 읽기/쓰기 모두 차단
            fcntl.flock(f, fcntl.LOCK_EX)
            json.dump(data, f)
            fcntl.flock(f, fcntl.LOCK_UN)

    def check_and_throttle(self, estimated_tokens=1000, model="unknown"):
        """한도를 초과하면 대기하고, 대기 후 윈도우를 재평가합니다."""
        while True:
            metrics = self._read_metrics()
            now = time.time()

            # 1-minute window reset
            if now - metrics["window_start"] > 60:
                metrics = {"window_start": now, "tokens": 0, "requests": 0}

            # Check thresholds (80%)
            tpm_usage = (metrics["tokens"] + estimated_tokens) / self.limit_tpm
            rpm_usage = (metrics["requests"] + 1) / self.limit_rpm

            if tpm_usage > 0.8 or rpm_usage > 0.8:
                delay = 15 # Voluntary 15s delay
                print(f"⚠️ BudgetWatchdog: High usage detected for {model} (TPM {tpm_usage:.1%}, RPM {rpm_usage:.1%}). Throttling for {delay}s...")
                time.sleep(delay)
                # 15초 대기 후 조건이 변경되었을 수 있으므로 루프의 처음으로 돌아가 재평가
                continue
            
            # Update metrics (안전한 상태가 확인되었을 때만 더함)
            metrics["tokens"] += estimated_tokens
            metrics["requests"] += 1
            self._write_metrics(metrics)
            print(f"📊 Current Budget: TPM {tpm_usage:.1%}, RPM {rpm_usage:.1%}")
            break # 정상 처리 후 루프 탈출

def retry_with_backoff(fn, max_retries=5):
    for i in range(max_retries):
        try:
            return fn()
        except Exception as e:
            msg = str(e).lower()
            if "429" in msg or "rate limit" in msg or "quota" in msg:
                wait = (2 ** i) + 5 # Exponential backoff with base 5s
                print(f"🔄 429 Error/Quota Reached: Retrying in {wait}s (Attempt {i+1}/{max_retries})...")
                time.sleep(wait)
            else:
                raise e
    raise Exception("Max retries exceeded for API call")

# Integration Example for NightWatch
if __name__ == "__main__":
    import sys
    # Load next task to get estimated cost
    try:
        from task_runner import parse_tasks, TASKS_FILE
        task = parse_tasks(TASKS_FILE, get_all=False)
        tokens = task.get("cost", 2000) if task else 1000
        model_tag = task.get("tag", "DEFAULT") if task else "NONE"
    except ImportError:
        tokens = 2000
        model_tag = "UNKNOWN"

    watchdog = BudgetWatchdog()
    watchdog.check_and_throttle(estimated_tokens=tokens, model=model_tag)
