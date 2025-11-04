# Begin Development Session

You are starting a new development session.

## Steps

1. **Read Memory Bank** (MANDATORY):
   - Read `memory-bank/activeContext.md` in full
   - Read `memory-bank/progress.md` in full

2. **Confirm Context**:
   - Current phase and milestone
   - Current task (in progress)
   - Next 3 upcoming tasks
   - Recent changes from last session

3. **Report Status**:
   Present a clear session start summary

## Output Format

```markdown
# Development Session Started

## Current State
**Phase**: [Phase X: Name]
**Status**: [X/Y tasks complete]
**Current Milestone**: [Milestone name]

## Current Task
**Task ID**: [P#.#]
**Task Name**: [Name]
**Status**: [Not started | In progress | Blocked]

## Next 3 Tasks
1. [P#.#] - [Name] ([Estimated time])
2. [P#.#] - [Name] ([Estimated time])
3. [P#.#] - [Name] ([Estimated time])

## Recent Changes (Last Session)
- [Change 1]
- [Change 2]
- [Change 3]

## Active Decisions
- [Key decision 1]
- [Key decision 2]

## Ready to Proceed
✅ Context loaded. Use `/start-task [id]` to begin a task, or ask questions about the project.
```

## Important Notes

- This command is READ-ONLY (no file modifications)
- Use this at the start of EVERY development session
- If Memory Bank files are missing or outdated, warn the user
- If current task is unclear, suggest reviewing _docs/task-list.md
