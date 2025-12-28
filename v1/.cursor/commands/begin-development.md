# Begin Development Session

You are starting a development session (new or resuming from pause).

## Steps

1. **Check for Pause Checkpoint** (FIRST):
   - Check if `memory-bank/pauseCheckpoint.md` exists
   - If it exists: This is a RESUME session (read checkpoint)
   - If it doesn't exist: This is a NEW session

2. **Read Memory Bank** (MANDATORY):
   - Read `memory-bank/activeContext.md` in full
   - Read `memory-bank/progress.md` in full

3. **Confirm Context**:
   - Current phase and milestone
   - Current task (in progress)
   - Next 3 upcoming tasks
   - Recent changes from last session
   - If resuming: What was paused and why

4. **Report Status**:
   Present a clear session start summary (format depends on new vs resume)

## Output Format

### For NEW Session (no pauseCheckpoint.md)

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
✅ Context loaded. Use `/plan [id]` to begin a task, or ask questions about the project.
```

### For RESUME Session (pauseCheckpoint.md exists)

```markdown
# Development Session Resumed

🔄 **Resuming from pause checkpoint**

## Last Session Summary
**Paused**: [Date/Time]
**Duration**: [X hours ago / Y days ago]

## Work Completed Before Pause
- ✅ [Task 1]
- ✅ [Task 2]
- ✅ [Task 3]

## Work In Progress (Paused)
**Task ID**: [P#.#]
**Task Name**: [Name]
**Progress**: [X% complete]
**State**: [What was done, what remains]

## Next Steps (From Checkpoint)
1. [Specific next step 1]
2. [Specific next step 2]
3. [Specific next step 3]

## Current State
**Phase**: [Phase X: Name]
**Status**: [X/Y tasks complete]
**Branch**: [branch-name]
**Working Directory**: [CLEAN / Has uncommitted changes]
**Tests**: [All passing / X failing]

## Open Questions/Blockers (if any)
- [Question 1]
- [Blocker 1]

## Ready to Resume
✅ Checkpoint loaded. Ready to continue with: [Next specific action]

Type 'yes' to continue, or ask questions about the paused work.
```

## Important Notes

- This command is READ-ONLY (no file modifications)
- Use this at the start of EVERY development session
- Automatically detects pause checkpoint and adjusts behavior
- If resuming: delete pauseCheckpoint.md ONLY after user confirms continuation
- If Memory Bank files are missing or outdated, warn the user
- If current task is unclear, suggest reviewing _docs/task-list.md

## Checkpoint Cleanup

After user confirms continuation from pause:
- Delete `memory-bank/pauseCheckpoint.md`
- This prevents treating future sessions as resumes
- Only delete AFTER user says "yes" or equivalent confirmation
