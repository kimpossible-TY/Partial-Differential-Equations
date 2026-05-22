# NightWatch Architecture

This document describes the current NightWatch/OpenClaw runtime as it exists in this repository.

It is not a speculative design note. The goal is to explain the implemented control flow, the canonical code paths, and the boundaries between runtime layers.

## Goal

NightWatch exists to run agent-driven work in a controlled loop with:

- a planner/worker execution split
- explicit OpenClaw gateway configuration
- compact memory retrieval instead of raw transcript replay
- task-specific prompt packing
- CI self-healing as a separate operational path

## Canonical Code Paths

The canonical NightWatch runtime now lives under `Tools/nightwatch/`.

### Package Modules

- `Tools/nightwatch/shell.py`
  command execution helpers
- `Tools/nightwatch/gateway.py`
  OpenClaw gateway patching, model routing, and agent discovery symlinks
- `Tools/nightwatch/permissions.py`
  temporary manifest permission widening and restore
- `Tools/nightwatch/tasks.py`
  `TASKS.md` parsing and task completion helpers
- `Tools/nightwatch/context_extractors.py`
  task classification, file/log extraction, and short summaries
- `Tools/nightwatch/memory_store.py`
  compact JSONL-backed task memory and retrieval
- `Tools/nightwatch/context_packer.py`
  token-bounded context construction with task-type-aware quotas

### Runtime Entrypoints

- `Tools/nightwatch_executor.py`
  main task execution path for `TASKS.md`
- `scripts/ci_fix_orchestrator.py`
  CI self-healing path driven by failing logs

### Legacy Compatibility Files

These still exist as compatibility wrappers and should not be treated as the primary implementation layer:

- `Tools/nightwatch_config.py`
- `Tools/task_runner.py`

## Architecture Overview

```text
TASKS.md or CI log
    |
    v
task classification / log extraction
    |
    v
memory retrieval from .openclaw_memory/
    |
    v
context packing with quotas and token caps
    |
    v
OpenClaw planner phase
    |
    v
plan.md summary re-ingested into memory
    |
    v
OpenClaw worker phase
    |
    v
git add / commit / downstream CI or PR flow
```

## Runtime Layers

## 1. Task Intake Layer

NightWatch currently has two intake paths.

### A. Task Queue Path

`Tools/nightwatch_executor.py` reads task metadata from:

- `nightwatch_bulk_tasks.json`, if present
- otherwise `TITLE`, `TAG`, and `task_body.txt`

`Tools/nightwatch/tasks.py` remains the shared parser for `TASKS.md`.

### B. CI Self-Healing Path

`scripts/ci_fix_orchestrator.py` reads a failing CI log file and treats the log as the task input.

This path is separate because its primary evidence source is not a task description but a failure trace.

## 2. Gateway and Model Layer

`Tools/nightwatch/gateway.py` is responsible for preparing `.openclaw_config/openclaw.json`.

It performs four core jobs:

1. Create a minimal config if one does not already exist
2. Point the runtime at the correct gateway port
3. Attach token auth when needed
4. Route the role to the correct model

Current model mapping:

- `PLANNER` -> `google/gemini-3.1-pro-preview`
- `WORKER` -> `openai/mlx-community/Qwen2.5-Coder-3B-Instruct-4bit`
- `PRO` -> `google/gemini-3.1-pro-preview`
- `FLASH` -> `google/gemini-3-flash-preview`
- `LOCAL` -> `openai/mlx-community/Qwen2.5-Coder-3B-Instruct-4bit`

The gateway layer also creates discovery symlinks under `.openclaw_config/agents/` so the OpenClaw runtime can find:

- `tool-architect`
- `math-typst-specialist`
- `ci-fixer`

## 3. Planner / Worker Execution Layer

The executor and CI orchestrator both follow the same high-level pattern:

1. Build compact context
2. Patch config for `PLANNER`
3. Start `openclaw-gateway`
4. Run the planner agent
5. Read and summarize `plan.md`
6. Patch config for `WORKER`
7. Run the worker agent with refreshed packed context

This split exists to keep expensive strategic reasoning separate from local code execution.

## 4. Memory and Context Layer

This is the major architectural change from the earlier NightWatch design.

Older flows tended to pass long task bodies, large logs, and broad repository context directly into prompts.
The current runtime inserts a dedicated memory and packing layer before the planner call.

### Memory Store

`Tools/nightwatch/memory_store.py` stores compact entries under `.openclaw_memory/`.

Current storage layout:

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

The store records compact artifacts such as:

- task summaries
- file summaries
- log summaries
- decisions
- current session state

### Context Extraction

`Tools/nightwatch/context_extractors.py` prepares raw input for retrieval and packing:

- classifies tasks into `ci_fix`, `math_typst`, or `general`
- extracts relevant file paths from tasks or logs
- extracts short error-focused log excerpts
- summarizes files and `plan.md`

### Retrieval

`Tools/nightwatch/memory_store.py` retrieves entries lexically and scores them using:

- task type match
- entry kind
- keyword overlap
- title overlap
- exact path match
- path mention in summaries
- recency
- task-type-specific query token bonuses

Each retrieved item includes:

- `retrieval_score`
- `retrieval_score_breakdown`

### Context Packing

`Tools/nightwatch/context_packer.py` converts retrieved memory plus the current task into a prompt pack.

It does three important things:

1. limits each section with local token caps
2. applies per-task-type bucket quotas
3. drops lower-priority sections when the global budget would be exceeded

This means NightWatch no longer blindly forwards top-k retrieval results. It selects by bucket according to task type.

Current examples:

- `ci_fix`
  logs and decisions are prioritized
- `math_typst`
  file summaries and related tasks are prioritized
- `general`
  uses a balanced quota profile

For details, see:

- [Memory and Context Architecture](./memory-and-context-architecture.md)
- [Retrieval and Packing](./retrieval-and-packing.md)

## 5. Permission Layer

`Tools/nightwatch/permissions.py` temporarily widens agent write permissions by rewriting agent manifests and later restoring them.

This is an operational convenience layer, not a trust boundary by itself.
It should be treated carefully because it mutates manifest files in place.

## 6. Commit and Output Layer

At the end of a successful executor run, NightWatch:

- stages changes
- checks whether there is anything to commit
- creates a normal commit or an empty marker commit

The CI self-healing path additionally:

- checks retry limits
- may send Discord notifications
- may push the fix branch in GitHub Actions

## Task-Type-Specific Behavior

The current runtime uses task classification to shape both retrieval and packing.

### `ci_fix`

- evidence source is usually logs
- retrieval favors `log_summary` and `decision`
- packing keeps 1-2 logs, 1-2 decisions, and a small file set

### `math_typst`

- evidence source is usually files and prior content work
- retrieval favors `file_summary` and `task_summary`
- packing keeps more file and task memory and usually drops logs

### `general`

- uses balanced retrieval and packing defaults

## Observability and Debugging

The runtime now emits two useful debug streams.

### Retrieval Debug

Printed after retrieval and before packing.

Shows:

- bucket name
- item label
- retrieval score
- score breakdown

This is the main tool for tuning ranking weights.

### Pack Debug

Printed after packing.

Shows:

- estimated token usage
- omitted sections
- quota usage by bucket

This is the main tool for tuning pack quotas and token budgets.

## What Changed From the Earlier Design

The older NightWatch document focused on:

- tag-driven model selection
- container sandboxing as the center of the flow
- scheduled autonomous PR loops

Those ideas still matter, but they are no longer the best description of the implemented architecture.

The current design centers on:

- canonical runtime modules under `Tools/nightwatch/`
- planner/worker split
- compact memory retrieval
- quota-based context packing
- separate CI self-healing orchestration

## Related Documents

- [Architecture Map](../00-overview/architecture-map.md)
- [Network Architecture](../10-workspace/network-architecture.md)
- [Memory and Context Architecture](./memory-and-context-architecture.md)
- [Retrieval and Packing](./retrieval-and-packing.md)
