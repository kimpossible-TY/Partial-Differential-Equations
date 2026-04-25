#!/usr/bin/env python3
"""Legacy compatibility entrypoint for task parsing."""

from nightwatch.tasks import (
    MODEL_COSTS,
    MODEL_ROUTES,
    TASKS_FILE,
    main,
    mark_task_done,
    parse_tasks,
)


if __name__ == "__main__":
    main()
