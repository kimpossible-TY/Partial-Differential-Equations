# Documentation Index

`Doc/` is the canonical documentation root for this workspace.

On this macOS workspace, `Doc/` and `doc/` may resolve to the same directory because the filesystem is case-insensitive. Use `Doc/` consistently in links, scripts, and new documentation.

## Directory Map

### `00-overview/`
- Entry points for new readers.
- High-level architecture map and glossary.

### `10-workspace/`
- Workspace runtime, network, and local development conventions.
- Environment-level material that is not specific to one agent.

### `20-agents/`
- OpenClaw, NightWatch, agent personas, memory store, retrieval, and context packing.
- Core agent architecture lives here.

### `30-operations/`
- Runbooks, CI workflows, debugging procedures, and recurring operational tasks.

### `40-guides/`
- User-facing guides and workflows, such as editor usage or PDF-to-Typst conversion.

### `90-reference/`
- Stable reference material such as environment variables, file layout, and conventions.

### `99-archive/`
- Legacy notes and material kept for historical context but no longer treated as the primary source of truth.

## Reading Order

If you are new to the system, start here:

1. [Architecture Map](./00-overview/architecture-map.md)
2. [NightWatch Architecture](./20-agents/nightwatch-architecture.md)
3. [Memory and Context Architecture](./20-agents/memory-and-context-architecture.md)
4. [Retrieval and Packing](./20-agents/retrieval-and-packing.md)
5. [Network Architecture](./10-workspace/network-architecture.md)

## Current Document Map

### Overview
- [Architecture Map](./00-overview/architecture-map.md)

### Workspace
- [Network Architecture](./10-workspace/network-architecture.md)
- [Code Style Guide](./10-workspace/code-style-guide.md)

### Agents
- [OpenClaw Discord Setup](./20-agents/openclaw-discord-setup.md)
- [Multi-Agent Personas](./20-agents/multi-agent-personas.md)
- [NightWatch Architecture](./20-agents/nightwatch-architecture.md)
- [Memory and Context Architecture](./20-agents/memory-and-context-architecture.md)
- [Retrieval and Packing](./20-agents/retrieval-and-packing.md)

### Guides
- [PDF to Typst Guide](./40-guides/pdf-to-typst-guide.md)
- [Neovim CodeCompanion Guide](./40-guides/neovim-codecompanion-guide.md)

### Archive
- [Todo List](./99-archive/todo-list.md)
