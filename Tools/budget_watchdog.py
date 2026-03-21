import time
import json
import os
from pathlib import Path

class BudgetWatchdog:
    def __init__(self, limit_tpm=80000, limit_rpm=1000):
        self.limit_tpm = limit_tpm
        self.limit_rpm = limit_rpm
        self.usage_file = Path("/workspace/.usage_metrics.json")
        self.load_metrics()

    def load_metrics(self):
        if self.usage_file.exists():
            try:
                self.metrics = json.loads(self.usage_file.read_text())
            except:
                self.metrics = {"window_start": time.time(), "tokens": 0, "requests": 0}
        else:
            self.metrics = {"window_start": time.time(), "tokens": 0, "requests": 0}

    def save_metrics(self):
        self.usage_file.write_text(json.dumps(self.metrics))

    def check_and_throttle(self, estimated_tokens=1000, model="unknown"):
        now = time.time()
        # 1-minute window reset
        if now - self.metrics["window_start"] > 60:
            self.metrics = {"window_start": now, "tokens": 0, "requests": 0}

        # Check thresholds (80%)
        tpm_usage = (self.metrics["tokens"] + estimated_tokens) / self.limit_tpm
        rpm_usage = (self.metrics["requests"] + 1) / self.limit_rpm

        if tpm_usage > 0.8 or rpm_usage > 0.8:
            delay = 15 # Voluntary 15s delay
            print(f"⚠️ BudgetWatchdog: High usage detected for {model} (TPM {tpm_usage:.1%}, RPM {rpm_usage:.1%}). Throttling for {delay}s...")
            time.sleep(delay)
        
        # Update metrics
        self.metrics["tokens"] += estimated_tokens
        self.metrics["requests"] += 1
        self.save_metrics()
        print(f"📊 Current Budget: TPM {tpm_usage:.1%}, RPM {rpm_usage:.1%}")

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
    except:
        tokens = 2000
        model_tag = "UNKNOWN"

    watchdog = BudgetWatchdog()
    watchdog.check_and_throttle(estimated_tokens=tokens, model=model_tag)
