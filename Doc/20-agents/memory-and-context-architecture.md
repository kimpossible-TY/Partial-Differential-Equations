# Memory and Context Architecture

This document explains how the current NightWatch/OpenClaw runtime avoids replaying raw history on every agent call.

## Goal

The system should send:
- current task intent
- relevant state
- retrieved compact memory
- small log or file excerpts

It should not send:
- full session history
- full CI logs by default
- entire file contents unless explicitly required

## Core Components

### `Tools/nightwatch/memory_store.py`
- Stores compact JSONL entries under `.openclaw_memory/`
- Tracks session state, working summary, task summaries, file summaries, decisions, and log summaries
- Retrieves entries lexically with task-type-aware scoring

### `Tools/nightwatch/context_extractors.py`
- Extracts relevant file paths from task text or logs
- Builds short log excerpts centered on errors
- Summarizes files and `plan.md`
- Classifies tasks into `ci_fix`, `math_typst`, or `general`

### `Tools/nightwatch/context_packer.py`
- Builds the final prompt context inside a token budget
- Applies task-type-specific quotas to retrieved memory buckets
- Emits pack metadata for debugging

## Storage Layout

```text
.openclaw_memory/
  state/
    session_state.json
    working_summary.md
    decisions.jsonl
    open_issues.jsonl
  chunks/
    files.jsonl
    logs.jsonl
    tasks.jsonl
```

## Retrieval Flow

1. Classify the current task.
2. Extract relevant paths and short excerpts.
3. Retrieve memory entries using lexical overlap and weighted scoring.
4. Rank by task type, kind, path match, keyword overlap, and recency.
5. Pass retrieved buckets to the context packer.

## Pack Flow

1. Build fixed sections such as `GOAL`, `CURRENT_STATE`, and `TASK_BODY`.
2. Select retrieved items by task-type quota.
3. Trim each section to a local token cap.
4. Drop lower-priority sections if the global budget would be exceeded.

## Why This Exists

Without this layer, long-running NightWatch sessions become progressively more expensive because the runtime keeps replaying raw history, logs, and file content. The current architecture keeps prompts stable by treating memory as compact state rather than transcript replay.

