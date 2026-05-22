"""JSONL-backed memory store for NightWatch context retrieval."""

from __future__ import annotations

import json
from collections import defaultdict
from datetime import datetime, timezone
from pathlib import Path

from nightwatch.context_extractors import extract_keywords, truncate_text


TASK_TYPE_WEIGHTS = {
    "ci_fix": {
        "base_same_type": 5,
        "base_other_type": -3,
        "path_match": 6,
        "path_mention": 3,
        "keyword_overlap": 2,
        "title_overlap": 1,
        "recency": 3,
        "kind_weights": {
            "decision": 4,
            "log_summary": 6,
            "file_summary": 2,
            "task_summary": 2,
            "open_issue": 2,
        },
        "query_token_bonus": {
            "traceback": {"log_summary": 4, "decision": 2},
            "error": {"log_summary": 4, "decision": 2},
            "failed": {"log_summary": 3, "decision": 2},
            "workflow": {"decision": 2, "task_summary": 2},
        },
    },
    "math_typst": {
        "base_same_type": 5,
        "base_other_type": -2,
        "path_match": 5,
        "path_mention": 2,
        "keyword_overlap": 3,
        "title_overlap": 2,
        "recency": 2,
        "kind_weights": {
            "decision": 2,
            "log_summary": 0,
            "file_summary": 6,
            "task_summary": 4,
            "open_issue": 1,
        },
        "query_token_bonus": {
            "typst": {"file_summary": 4, "task_summary": 2},
            "theorem": {"file_summary": 3, "task_summary": 2},
            "riemann": {"file_summary": 3, "task_summary": 2},
            "pde": {"file_summary": 3, "task_summary": 2},
        },
    },
    "general": {
        "base_same_type": 4,
        "base_other_type": 0,
        "path_match": 5,
        "path_mention": 2,
        "keyword_overlap": 2,
        "title_overlap": 2,
        "recency": 2,
        "kind_weights": {
            "decision": 3,
            "log_summary": 1,
            "file_summary": 4,
            "task_summary": 3,
            "open_issue": 2,
        },
        "query_token_bonus": {},
    },
}


class MemoryStore:
    """Persist compact task memory and retrieve it lexically."""

    def __init__(self, root: str | Path = ".openclaw_memory"):
        self.root = Path(root)
        self.state_dir = self.root / "state"
        self.chunks_dir = self.root / "chunks"
        self.index_dir = self.root / "index"

    def init_store(self) -> None:
        for directory in (self.root, self.state_dir, self.chunks_dir, self.index_dir):
            directory.mkdir(parents=True, exist_ok=True)

    def _path_for_kind(self, kind: str) -> Path:
        mapping = {
            "decision": self.state_dir / "decisions.jsonl",
            "open_issue": self.state_dir / "open_issues.jsonl",
            "file_summary": self.chunks_dir / "files.jsonl",
            "log_summary": self.chunks_dir / "logs.jsonl",
            "task_summary": self.chunks_dir / "tasks.jsonl",
        }
        return mapping.get(kind, self.chunks_dir / "misc.jsonl")

    def _append_entry(self, payload: dict) -> None:
        self.init_store()
        payload.setdefault("ts", datetime.now(timezone.utc).isoformat())
        payload.setdefault("keywords", extract_keywords(payload.get("summary", "")))
        payload.setdefault("title_keywords", extract_keywords(payload.get("title", "")))
        target = self._path_for_kind(payload["kind"])
        with open(target, "a", encoding="utf-8") as handle:
            handle.write(json.dumps(payload, ensure_ascii=False) + "\n")

    def update_session_state(self, **fields) -> None:
        self.init_store()
        path = self.state_dir / "session_state.json"
        current = {}
        if path.exists():
            current = json.loads(path.read_text(encoding="utf-8"))
        current.update(fields)
        current["updated_at"] = datetime.now(timezone.utc).isoformat()
        path.write_text(json.dumps(current, ensure_ascii=False, indent=2), encoding="utf-8")

    def write_working_summary(self, summary: str) -> None:
        self.init_store()
        path = self.state_dir / "working_summary.md"
        path.write_text(truncate_text(summary.strip(), 4000) + "\n", encoding="utf-8")

    def read_session_state(self) -> dict:
        path = self.state_dir / "session_state.json"
        if not path.exists():
            return {}
        return json.loads(path.read_text(encoding="utf-8"))

    def read_working_summary(self) -> str:
        path = self.state_dir / "working_summary.md"
        if not path.exists():
            return ""
        return path.read_text(encoding="utf-8")

    def append_task_summary(self, title: str, summary: str, task_type: str, files: list[str] | None = None) -> None:
        self._append_entry(
            {
                "kind": "task_summary",
                "title": title,
                "task_type": task_type,
                "summary": truncate_text(summary, 900),
                "files": files or [],
                "tags": [task_type],
            }
        )

    def append_decision(self, summary: str, task_type: str, files: list[str] | None = None) -> None:
        self._append_entry(
            {
                "kind": "decision",
                "task_type": task_type,
                "summary": truncate_text(summary, 600),
                "files": files or [],
                "tags": [task_type, "decision"],
            }
        )

    def append_log_summary(self, summary: str, task_type: str, files: list[str] | None = None) -> None:
        self._append_entry(
            {
                "kind": "log_summary",
                "task_type": task_type,
                "summary": truncate_text(summary, 700),
                "files": files or [],
                "tags": [task_type, "log"],
            }
        )

    def append_file_summary(self, path: str, summary: str, task_type: str = "general", symbols: list[str] | None = None) -> None:
        self._append_entry(
            {
                "kind": "file_summary",
                "path": path,
                "task_type": task_type,
                "summary": truncate_text(summary, 700),
                "symbols": symbols or [],
                "files": [path],
                "tags": [task_type, "file"],
            }
        )

    def _load_entries(self, path: Path) -> list[dict]:
        if not path.exists():
            return []
        entries: list[dict] = []
        with open(path, "r", encoding="utf-8") as handle:
            for line in handle:
                line = line.strip()
                if not line:
                    continue
                try:
                    entries.append(json.loads(line))
                except json.JSONDecodeError:
                    continue
        return entries

    def _all_entries(self) -> list[dict]:
        self.init_store()
        entries: list[dict] = []
        for path in (
            self.state_dir / "decisions.jsonl",
            self.state_dir / "open_issues.jsonl",
            self.chunks_dir / "files.jsonl",
            self.chunks_dir / "logs.jsonl",
            self.chunks_dir / "tasks.jsonl",
            self.chunks_dir / "misc.jsonl",
        ):
            entries.extend(self._load_entries(path))
        return entries

    def _get_profile(self, task_type: str | None) -> dict:
        return TASK_TYPE_WEIGHTS.get(task_type or "general", TASK_TYPE_WEIGHTS["general"])

    def _recency_score(self, entry: dict, weight: int) -> int:
        ts = entry.get("ts")
        if not ts:
            return 0
        try:
            dt = datetime.fromisoformat(ts.replace("Z", "+00:00"))
        except ValueError:
            return 0

        age_hours = max(0.0, (datetime.now(timezone.utc) - dt).total_seconds() / 3600.0)
        if age_hours <= 6:
            return weight
        if age_hours <= 24:
            return max(1, weight - 1)
        if age_hours <= 72:
            return 1
        return 0

    def _score_entry(self, entry: dict, query_terms: set[str], task_type: str | None, candidate_paths: set[str]) -> tuple[int, dict]:
        profile = self._get_profile(task_type)
        contributions: dict[str, int] = defaultdict(int)
        entry_type = entry.get("task_type")
        kind = entry.get("kind", "other")

        if task_type and entry_type == task_type:
            contributions["same_task_type"] += profile["base_same_type"]
        elif task_type and entry_type not in {None, task_type}:
            contributions["other_task_type"] += profile["base_other_type"]

        contributions["kind_weight"] += profile["kind_weights"].get(kind, 0)

        entry_terms = set(entry.get("keywords", []))
        contributions["keyword_overlap"] += len(query_terms & entry_terms) * profile["keyword_overlap"]

        title_terms = set(entry.get("title_keywords", []))
        contributions["title_overlap"] += len(query_terms & title_terms) * profile["title_overlap"]

        matched_paths = sum(1 for path in entry.get("files", []) if path in candidate_paths)
        contributions["path_match"] += matched_paths * profile["path_match"]

        summary = entry.get("summary", "").lower()
        path_mentions = sum(1 for path in candidate_paths if path and path.lower() in summary)
        contributions["path_mention"] += path_mentions * profile["path_mention"]

        for token, kind_bonus in profile["query_token_bonus"].items():
            if token in query_terms:
                contributions["query_token_bonus"] += kind_bonus.get(kind, 0)

        contributions["recency"] += self._recency_score(entry, profile["recency"])

        score = sum(contributions.values())
        return score, dict(contributions)

    def retrieve(
        self,
        query: str,
        task_type: str | None = None,
        paths: list[str] | None = None,
        top_k: int = 8,
    ) -> dict[str, list[dict]]:
        query_terms = set(extract_keywords(query, limit=24))
        candidate_paths = set(paths or [])
        scored: list[tuple[int, dict]] = []

        for entry in self._all_entries():
            score, score_breakdown = self._score_entry(entry, query_terms, task_type, candidate_paths)
            if score > 0:
                enriched_entry = dict(entry)
                enriched_entry["retrieval_score"] = score
                enriched_entry["retrieval_score_breakdown"] = score_breakdown
                scored.append((score, enriched_entry))

        scored.sort(key=lambda item: item[0], reverse=True)
        buckets = {"decisions": [], "files": [], "logs": [], "tasks": [], "other": []}
        for _, entry in scored[:top_k]:
            kind = entry.get("kind")
            if kind == "decision":
                buckets["decisions"].append(entry)
            elif kind == "file_summary":
                buckets["files"].append(entry)
            elif kind == "log_summary":
                buckets["logs"].append(entry)
            elif kind == "task_summary":
                buckets["tasks"].append(entry)
            else:
                buckets["other"].append(entry)
        return buckets

    @staticmethod
    def format_retrieval_debug(retrieved: dict, limit_per_kind: int = 2) -> str:
        parts: list[str] = []
        for kind in ("decisions", "files", "logs", "tasks", "other"):
            items = retrieved.get(kind, [])
            if not items:
                continue
            snippets = []
            for entry in items[:limit_per_kind]:
                score = entry.get("retrieval_score", 0)
                breakdown = entry.get("retrieval_score_breakdown", {})
                active_terms = ", ".join(f"{k}={v}" for k, v in breakdown.items() if v)
                label = entry.get("path") or entry.get("title") or entry.get("summary", "")[:40]
                snippets.append(f"{label} [score={score}; {active_terms}]")
            parts.append(f"{kind}: " + " || ".join(snippets))
        return "\n".join(parts)
