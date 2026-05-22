# Retrieval and Packing

This document describes how retrieved memory is ranked and how context packing decides what actually reaches the model.

## Retrieval Scoring

`Tools/nightwatch/memory_store.py` scores entries using multiple signals:

- task type match
- memory kind weight
- keyword overlap
- title keyword overlap
- exact path match
- path mention in summary text
- query token bonuses
- recency

Each retrieved entry stores:
- `retrieval_score`
- `retrieval_score_breakdown`

This makes ranking inspectable during live runs.

## Task-Type Profiles

### `ci_fix`
- Prefer `log_summary` and `decision`
- Give bonuses for query tokens such as `traceback`, `error`, `failed`, and `workflow`
- Treat direct file path matches as strong signals

### `math_typst`
- Prefer `file_summary` and `task_summary`
- Give bonuses for query tokens such as `typst`, `theorem`, `riemann`, and `pde`
- Ignore logs unless they are unusually relevant

### `general`
- Use a balanced profile between files, tasks, and decisions

## Quota-Based Packing

`Tools/nightwatch/context_packer.py` does not blindly pack top-k results. It applies quotas by bucket.

### Current Default Quotas

#### `ci_fix`
- decisions: 1-2
- files: 1-2
- logs: 1-2
- tasks: 0-1

#### `math_typst`
- decisions: 0-1
- files: 2-3
- logs: 0
- tasks: 1-2

#### `general`
- decisions: 0-2
- files: 1-2
- logs: 0-1
- tasks: 0-2

## Debug Output

Two levels of debug output are emitted during runtime.

### Retrieval Ranking
- Printed right after retrieval
- Shows each bucket's top entries
- Includes `retrieval_score` and `retrieval_score_breakdown`

### Pack Summary
- Printed right after packing
- Shows estimated token usage
- Shows omitted sections
- Shows bucket quota usage such as `logs=2/3`

## Tuning Strategy

When tuning, inspect both:

1. Whether the correct entries are ranked near the top
2. Whether quota selection preserves the right kinds of evidence for the current task

If retrieval is right but packing is wrong, adjust quotas.
If packing is right but ranking is wrong, adjust weights.

