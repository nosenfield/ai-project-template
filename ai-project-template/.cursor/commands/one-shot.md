# One-Shot Phase Execution

Execute all remaining tasks in a phase autonomously.

**Usage**: `/one-shot Phase N`

**Mode**: Autonomous (see @autonomous-execution.mdc)

## Pre-Execution Checks

1. Verify working directory is clean: `git status`
2. Verify tests pass: `npm test`
3. Identify remaining tasks in phase

## Workflow

For each task:

1. **Read Context**
   - memory-bank/activeContext.md
   - memory-bank/progress.md
   - _docs/task-list.md

2. **Plan Silently** - Do not show plan to user

3. **Test-First Implementation**
   - Write failing tests (RED)
   - Implement to pass (GREEN)
   - Verify: `npm test`

4. **Update Documentation**
   - memory-bank/progress.md
   - _docs/task-tracker.md

5. **Commit**
   - Stage files explicitly (never `git add .`)
   - Follow commit approval workflow
   - See @commit-workflow-strict.mdc

6. **Continue Immediately** - Do not pause between tasks

## Phase Completion

After all tasks:
1. Full memory bank update
2. Generate phase summary in `_context-summaries/`
3. Report completion

## Error Handling

- **Test failures (3 retries)**: Mark `[!]`, halt execution
- **Pre-commit hook failures**: Report error, halt
- **Ambiguous requirements**: Ask for clarification

## Rules

**Required**: Write tests first, stage files explicitly, update tracker

**Forbidden**: `git add .`, `--no-verify`, AUTO_ACCEPT without approval
