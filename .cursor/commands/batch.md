# Batch Task Command

Execute multiple tasks sequentially in a single uninterrupted flow.

**Use this when**: You want to complete an entire phase or multiple related tasks without manual intervention between each task.

**Example**: `/batch 0.3 0.4 1.1 1.2` or `/batch phase-0` or `/batch 0.3-0.4`

## Execution Mode

This command operates in **autonomous mode**. The agent will:
- Execute tasks continuously without pausing between completions
- Handle commit approval workflow automatically (see @autonomous-execution.mdc)
- Only pause for errors, failures, ambiguity, or phase completion

For complete autonomous mode rules and commit approval workflow, see @autonomous-execution.mdc.

**Note**: The similar `/one-shot Phase N` command provides the same autonomous execution for entire phases.

---

## Workflow Overview

This command performs repeated task executions:
1. Execute task 1 (plan → implement → test → document → commit)
2. Execute task 2 (plan → implement → test → document → commit)
3. Execute task 3 (plan → implement → test → document → commit)
4. ... continue until all tasks complete or failure occurs

---

## Input Formats

### Individual Tasks
```
/batch 0.3 0.4 1.1
```
Execute tasks 0.3, 0.4, and 1.1 in sequence.

### Task Range
```
/batch 0.3-0.4
```
Execute all tasks from 0.3 through 0.4 (inclusive).

### Phase Completion
```
/batch phase-0
```
Execute all remaining tasks in Phase 0.

### Mixed Format
```
/batch 0.3-0.4 1.1 1.3-1.5
```
Execute tasks 0.3, 0.4, 1.1, 1.3, 1.4, 1.5 in sequence.

---

## Step-by-Step Execution

For each task in the batch:

### 1. Pre-Task Setup

```
Starting Task [N of M]: [task-id] - [task name]

Progress: [N]/M tasks complete
```

### 2. Execute One-Shot Workflow

Follow the complete one-shot process for this task:

1. **Read Context**
   - memory-bank/activeContext.md
   - memory-bank/progress.md
   - _docs/task-list.md (find task-id)
   - .cursor/rules/base.mdc + domain rules

2. **Silent Planning**
   - Files to modify
   - Implementation steps
   - Risk assessment

3. **Test-First Implementation**
   - Write failing tests first (RED)
   - Implement to pass tests (GREEN)
   - Verify all tests pass

4. **Update Documentation**
   - Update memory-bank/activeContext.md
   - Update memory-bank/progress.md

5. **Update Task Tracker**
   - Update _docs/task-tracker.md
   - Mark task complete
   - Update progress percentages

6. **Commit via Approval Workflow**

   Follow the complete commit approval workflow as defined in @autonomous-execution.mdc § "Commit Approval Workflow".

   **Safety Checks:**
   - No secrets or credentials (.env, keys, etc.)
   - No large files (> 10MB unless intentional)
   - No `node_modules/` or `__pycache__/`

   **Stage Files Explicitly:**
   ```bash
   git status --short
   git add path/to/file1.ts path/to/file2.ts path/to/test.test.ts
   ```
   **FORBIDDEN**: NEVER use `git add .` or `git add -A`

   **Create Commit:**
   ```bash
   git commit -m "$(cat <<'EOF'
   <type>: <short description>

   <detailed description>

   - Key change 1
   - Key change 2

   Task: [task-id] - [task name]
   EOF
   )"
   ```

   **Handle Claude Review Iterations:**

   The pre-commit hook will trigger Claude review. The agent must:
   1. Analyze Claude's review feedback (see standardized format in @autonomous-execution.mdc)
   2. Decide action based on feedback:
      - **Approval + no issues**: Use `AUTO_ACCEPT=true` immediately
      - **Approval + non-blocking recommendations**: Decide if significant → implement or defer
      - **Issues found**: Fix issues → request new approval
   3. Iterate until approval received
   4. Finalize with `AUTO_ACCEPT=true` after approval with no changes

   **Example:**
   ```bash
   # First attempt
   git commit -m "feat: implement feature X"
   # Claude reviews → suggests improvements

   # Fix and retry
   git commit -m "feat: implement feature X"
   # Claude reviews → APPROVED

   # Final commit with AUTO_ACCEPT
   AUTO_ACCEPT=true git commit -m "feat: implement feature X"
   # ✅ Commit succeeds
   ```

   **FORBIDDEN**: NEVER use `--no-verify` or `-n` flags

   **Verify Commit:**
   ```bash
   git log --oneline -1
   ```

### 3. Post-Task Reporting

```
Task [N of M] COMPLETED: [task-id]

Commit: [hash]
Files: [count] files changed
Tests: All passing

Continuing to next task...
```

### 4. Inter-Task Validation

Before proceeding to next task:
- All tests still passing
- No uncommitted changes
- Memory bank updated
- Task tracker updated
- Git working directory clean

#### ⚠️ CRITICAL: Reset Commit Approval State

**Each new task starts with NO approval.**

When moving to the next task:
- ❌ **DO NOT** use `AUTO_ACCEPT=true` on the first commit attempt
- ❌ **DO NOT** carry forward approval from previous task
- ✅ **MUST** go through full Claude review cycle for first commit
- ✅ **ONLY** use `AUTO_ACCEPT=true` after receiving approval for THIS task's commit

---

## Error Handling

### Test Failure Strategy

If tests fail after 3 implementation attempts:

```
BATCH HALTED

Task: [task-id] failed after 3 attempts

Error:
[error details]

Completed: [N-1]/M tasks
Remaining: [list of remaining tasks]

Fix required before continuing

Options:
1. Fix the issue manually
2. Skip this task and continue
3. Abort batch (already halted)
```

**CRITICAL**: Do NOT commit failing code. Stop the batch immediately.

### Dependency Failure

If a task depends on a failed previous task:

```
DEPENDENCY CONFLICT

Task [task-id] depends on [failed-task-id]

Skipping remaining tasks: [list]

Completed: [N]/M tasks successfully
```

### Ambiguous Requirements

If task requirements are unclear:

```
CLARIFICATION NEEDED

Task: [task-id]

Question: [specific question about requirements]

Batch paused at: [N]/M tasks
Completed: [list of completed tasks]
Remaining: [list of remaining tasks]

Waiting for user input...
```

---

## Batch Progress Reporting

### Start of Batch

```
BATCH EXECUTION STARTED

Tasks queued: [M]
1. [task-id-1] - [task name]
2. [task-id-2] - [task name]
3. [task-id-3] - [task name]

Estimated time: [X-Y] minutes
Starting first task...
```

### During Execution

```
Progress: [N]/M tasks complete

Completed:
- [task-id-1] - [commit hash]
- [task-id-2] - [commit hash]

Current:
- [task-id-3] - Implementing...

Remaining:
- [task-id-4]
- [task-id-5]
```

### End of Batch

```
BATCH COMPLETED

Summary:
- [M]/[M] tasks completed successfully
- [M] commits created

Commits:
- [hash1] feat: [task-1 summary]
- [hash2] feat: [task-2 summary]
- [hash3] fix: [task-3 summary]

Files changed: [total count] files
Tests: All passing

Ready for review and push.
```

---

## Safety & Validation

### Pre-Batch Checks

Before starting batch:
1. Working directory is clean (no uncommitted changes)
2. All current tests passing
3. Memory bank is up to date
4. All task IDs valid in task-list.md

If checks fail:
```
PRE-BATCH VALIDATION FAILED

Issue: [description]

Please resolve before starting batch execution.
```

### Post-Batch Checks

After completing batch:
1. All tests passing across entire codebase
2. No uncommitted changes remaining
3. Memory bank reflects all completed tasks
4. Task tracker updated for all tasks
5. Each task has corresponding commit

---

## Commit Strategy

### One Commit Per Task

Each task gets its own atomic commit:

```
Task 0.3 → Commit: "feat: Implement configuration management system"
Task 0.4 → Commit: "feat: Add structured logging utilities"
Task 1.1 → Commit: "feat: Create DynamoDB client wrapper"
```

**Benefits**:
- Easy to review individual changes
- Can cherry-pick or revert specific tasks
- Clear git history
- Bisect-friendly for debugging

### Batch Commit Message Format

Same as one-shot (conventional commits):

```
<type>: <short description>

<detailed description>

- Key change 1
- Key change 2
- Key change 3
```

---

## Recovery & Continuation

### Resuming After Failure

If batch halts at task N:

```bash
# Fix the issue manually

# Resume from next task
/batch [task-N+1] [task-N+2] ...

# OR use range notation
/batch [N+1]-[M]
```

### Skipping Tasks

If a task needs to be skipped:

```
User requested skip: [task-id]

Marking as skipped in task tracker
Continuing to next task...
```

Task tracker will show:
```
- [~] Task X.X - [name]
```

---

## Performance Optimization

### Parallel Test Execution

If test suite supports it:
```bash
pytest -n auto  # Use all CPU cores
```

### Incremental Testing

Only run tests related to changed files:
```bash
pytest --lf  # Run last failed first
pytest --ff  # Run failures first, then all
```

---

## Use Cases

### Complete a Phase

```
/batch phase-0
```
Executes all remaining tasks in Phase 0 (e.g., 0.3, 0.4 if 0.1-0.2 done).

### Knock Out Foundation Tasks

```
/batch 0.3-0.4
```
Complete configuration and logging setup in one session.

### Batch Related Features

```
/batch 1.1 1.2 1.3
```
Implement DynamoDB client, S3 client, and data models together.

### Sprint Through Testing Tasks

```
/batch 2.5-2.8
```
Add all test coverage for a specific module.

---

## Rules & Constraints

### MANDATORY

1. Execute tasks in specified order
2. Complete one-shot workflow for each task
3. Create one commit per task
4. Stage files by name
5. Stop on test failures
6. Update memory bank after each task
7. Update task tracker after each task
8. Report progress clearly
9. Validate pre/post conditions

### FORBIDDEN

1. Skip tests to continue batch
2. Commit failing code
3. Combine multiple tasks in one commit
4. Use of `git add .` or `git add -A`
5. Use of `--no-verify` or `-n`
6. Use `AUTO_ACCEPT=true` without approval
7. Use `AUTO_ACCEPT=true` after making changes post-approval
8. Use `AUTO_ACCEPT=true` on first commit of NEW task (carry forward approval from previous task)
9. Continue if dependencies fail
10. Auto-push to remote
11. Ignore ambiguous requirements
12. Modify files outside task scope

---

## Example Execution

**User**: `/batch 0.3-0.4`

**AI executes**:

```
BATCH EXECUTION STARTED

Tasks queued: 2
1. 0.3 - Configuration Management System
2. 0.4 - Logging Utility Setup

Estimated time: 4-8 minutes
Starting first task...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Starting Task 1 of 2: 0.3 - Configuration Management System

Progress: 1/2 tasks

[Executes one-shot workflow for task 0.3]
- Reading context...
- Planning implementation...
- Writing tests... (12 tests created)
- Implementing src/utils/config.py...
- Running pytest... All pass
- Updating memory bank...
- Updating task tracker...
- Committing changes...

Task 1 of 2 COMPLETED: 0.3

Commit: a1b2c3d
Files: 4 files changed
Tests: 12 new, all passing

Continuing to next task...

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Starting Task 2 of 2: 0.4 - Logging Utility Setup

Progress: 2/2 tasks

[Executes one-shot workflow for task 0.4]
- Reading context...
- Planning implementation...
- Writing tests... (15 tests created)
- Implementing src/utils/logger.py...
- Running pytest... All pass
- Updating memory bank...
- Updating task tracker...
- Committing changes...

Task 2 of 2 COMPLETED: 0.4

Commit: d4e5f6g
Files: 3 files changed
Tests: 15 new, all passing

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

BATCH COMPLETED

Summary:
- 2/2 tasks completed successfully
- 2 commits created

Commits:
- a1b2c3d feat: Implement configuration management system
- d4e5f6g feat: Add structured logging utilities

Files changed: 7 files
Tests: 27 new tests, all passing

Phase 0 Progress: 4/4 tasks complete (100%)

Ready for review and push.
```

---

## When to Use vs Other Commands

### Use `/batch` when:
- Completing an entire phase
- Multiple related tasks ready to execute
- Tasks are well-defined and independent
- You want maximum velocity
- You trust autonomous execution

### Use `/one-shot` when:
- Single task execution
- Want to observe one task before committing to more
- Testing the workflow

### Use `/plan` → `/implement` → `/commit` when:
- Requirements are ambiguous
- Need to review plans
- Critical/risky changes
- Learning phase

---

## Troubleshooting

### "Batch halted due to test failure"
- Review error output
- Fix issue manually
- Resume: `/batch [next-task-id] ...`

### "Dependency conflict detected"
- Check task dependencies in task-list.md
- Complete prerequisite tasks first
- Reorder task sequence

### "Ambiguous requirements"
- Answer clarifying question
- Batch will auto-resume after answer

### "Working directory not clean"
- Commit or stash current changes
- Ensure clean slate before batch

---

**Remember:** The batch command is designed for velocity. Use it when you're confident in the task definitions and want to knock out multiple tasks in one session. For exploratory or risky work, use the approval-gated workflow instead.
