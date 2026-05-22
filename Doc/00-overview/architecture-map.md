# Architecture Map

This document is the shortest path to the current workspace architecture.

## Layers

### 1. Workspace Layer
- `start_workspace.sh` boots the local runtime.
- Tailscale, the local HTTP server, Typst watcher, and MLX server live here.

### 2. Agent Runtime Layer
- OpenClaw gateway and NightWatch orchestration drive automated agent execution.
- Canonical runtime modules live under `Tools/nightwatch/`.

### 3. Agent Identity Layer
- Agent personas and permissions live under `agents/`.
- `tool-architect`, `math-typst-specialist`, and `ci-fixer` have distinct roles.

### 4. Memory and Context Layer
- Compact task memory is stored under `.openclaw_memory/`.
- Retrieval pulls back only relevant summaries instead of replaying full history.
- Context packing applies task-type-aware quotas before building prompts.

### 5. Operations Layer
- `TASKS.md`, NightWatch executor flows, and CI self-healing live here.
- Planning and execution are separated into planner and worker phases.

## Key Paths

- `Tools/nightwatch/`: canonical NightWatch/OpenClaw runtime package
- `Tools/nightwatch_executor.py`: task executor entrypoint
- `scripts/ci_fix_orchestrator.py`: CI self-healing entrypoint
- `agents/`: agent personas and manifests
- `.openclaw/`: runtime state managed by OpenClaw
- `.openclaw_memory/`: compact memory store for retrieval and context packing

## Recommended Reading

1. [NightWatch Architecture](../20-agents/nightwatch-architecture.md)
2. [Memory and Context Architecture](../20-agents/memory-and-context-architecture.md)
3. [Retrieval and Packing](../20-agents/retrieval-and-packing.md)
4. [Network Architecture](../10-workspace/network-architecture.md)

