## Task Workflow

The current task is always in .tasks/current/spec.md
Current plan is always in .tasks/current/plan.md

## Commands

- /start-task — read task, analyze packages, create a plan and task list
- /next-task — pick the next unblocked task and start implementation
- /review-task — review progress and suggest next steps
- /sync-task — review all task files in .tasks/current/ and ensure they are consistent

## General Preferences

- Always write file contents in English
- Always use a conventional commits format
- Never modify files outside the packages mentioned in the task(spec.md)

## Task File Sync Rule

When any file inside .specs/current/ is modified (spec.md, plan.md, impact.md, tests.md),
review all other files in the same folder and update them if needed to stay consistent:

- spec.md changed → check if the plan.md approach still matches the scope
- plan.md changed → check if impact.md affected areas are still accurate, sync a task list
- impact.md changed → check if tests.md covers the new affected areas
- tests.md changed → check if acceptance criteria in spec.md need updating

Only update what is actually inconsistent. Do not rewrite files unnecessarily.
