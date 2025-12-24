# Batch Task Execution

Execute multiple tasks sequentially in a single uninterrupted flow.

**Usage**:
- `/batch 0.3 0.4 1.1` - Individual tasks
- `/batch 0.3-0.4` - Task range
- `/batch phase-0` - All tasks in phase

**Mode**: Autonomous (see @autonomous-execution.mdc)

## Workflow

For each task in batch:

1. **Read Context**
   - memory-bank/activeContext.md
   - memory-bank/progress.md
   - _docs/task-list.md

2. **Plan Silently** - Do not show plan to user

3. **Test-First Implementation**
   - Write failing tests (RED)
   - Implement to pass (GREEN)
   - Verify all tests pass

4. **Update Documentation**
   - memory-bank files
   - _docs/task-tracker.md

5. **Commit**
   - Stage files explicitly
   - Follow @commit-workflow-strict.mdc

6. **Continue Immediately** - No pause between tasks

## Batch Completion Report

```
BATCH COMPLETED

Summary:
- [M]/[M] tasks completed
- [M] commits created

Commits:
- [hash] feat: [summary]
- [hash] fix: [summary]

Ready for review and push.
```

## Error Handling

- **Test failures (3 retries)**: Halt, report remaining tasks
- **Dependency failure**: Skip dependent tasks
- **Ambiguous requirements**: Pause, ask for clarification

## Rules

**Required**: One commit per task, stage files explicitly, update tracker

**Forbidden**: `git add .`, `--no-verify`, combine tasks in one commit
