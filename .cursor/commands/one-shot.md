# One-Shot Phase Execution Command

Execute an entire phase autonomously from start to finish without user intervention.

**Use this when**: You want to complete all remaining tasks in a phase with maximum velocity and trust the agent to handle the full workflow autonomously.

**Example**: `/one-shot Phase 1` or `/one-shot Phase 0`

---

## Command Scope

This command executes **all remaining tasks in a specified phase** autonomously:
- Skips completed tasks (marked `[x]` in task tracker)
- Executes remaining tasks (marked `[ ]`, `[>]`, or `[!]`)
- Stops only for errors, failures, ambiguity, or phase completion

**For single task execution**, use `/task [task-id]` instead.

---

## Execution Mode

This command operates in **autonomous mode** as defined in @autonomous-execution.mdc.

### Key Autonomous Behaviors

**Continuous Execution:**
- Execute tasks sequentially without pausing between completions
- IMMEDIATELY continue to next task after successful commit
- DO NOT wait for user acknowledgment between tasks

**Automatic Commit Approval:**
- Handle Claude code review iterations automatically
- Implement significant recommendations when agent agrees
- Use `AUTO_ACCEPT=true` only after approval with no changes made
- Never use `--no-verify` or `-n` flags

**Smart Pausing:**
- ONLY pause for errors, failures, ambiguity, or phase completion
- DO NOT pause for successful task completions
- DO NOT pause for memory bank updates
- DO NOT pause for Claude review iterations

For complete autonomous mode rules, see @autonomous-execution.mdc.

---

## Workflow Overview

For each remaining task in the phase:

```
1. Read Context
   ├─ memory-bank/activeContext.md
   ├─ memory-bank/progress.md
   ├─ _docs/task-list.md (find task details)
   └─ .cursor/rules/*.mdc (relevant rules)

2. Plan Implementation (SILENTLY)
   ├─ Files to modify
   ├─ Implementation steps
   ├─ Test strategy
   └─ Risk assessment

3. Test-First Implementation
   ├─ Write tests first (RED)
   ├─ Implement to pass tests (GREEN)
   └─ Verify all tests pass

4. Update Documentation
   ├─ Update memory-bank/activeContext.md (if needed)
   ├─ Update memory-bank/progress.md
   └─ Update _docs/task-tracker.md

5. Commit via Approval Workflow
   ├─ Stage files explicitly
   ├─ Create commit with conventional message
   ├─ Handle Claude review iterations
   └─ Finalize with AUTO_ACCEPT=true when approved

6. IMMEDIATELY Continue to Next Task
   └─ NO PAUSE - proceed directly

After all tasks complete:

7. Phase Completion Procedures
   ├─ Full memory bank update
   ├─ Update task tracker (100% phase completion)
   ├─ Generate phase summary
   └─ Report completion to user
```

---

## Pre-Execution Validation

Before starting phase execution, verify:

### 1. Check Working Directory
```bash
git status
```
- [ ] Working directory is clean (no uncommitted changes)
- [ ] No untracked files that should be committed first

If not clean:
```
⚠️ WORKING DIRECTORY NOT CLEAN

Uncommitted changes detected:
[list files]

Please commit or stash changes before starting phase execution.
```

### 2. Check Current Tests
```bash
npm test
# OR pytest
```
- [ ] All current tests passing

If tests failing:
```
⚠️ TESTS CURRENTLY FAILING

Cannot start phase execution with failing tests:
[list failures]

Please fix failing tests first, then retry.
```

### 3. Identify Tasks to Execute

Read `_docs/task-tracker.md` and identify:
- Completed tasks: `[x]` - SKIP
- Not started: `[ ]` - EXECUTE
- In progress: `[>]` - EXECUTE (resume)
- Failed: `[!]` - EXECUTE (retry)
- Skipped: `[~]` - SKIP

If no remaining tasks:
```
✅ PHASE ALREADY COMPLETE

All tasks in Phase [N] are marked complete.

Nothing to execute.
```

If unclear which task to start:
```
⚠️ UNCLEAR STARTING POINT

Phase [N] has multiple in-progress tasks:
- [>] Task X.Y - [name]
- [>] Task X.Z - [name]

Which task should I start with?
A) Task X.Y
B) Task X.Z
C) Start from first incomplete task
```

### 4. Report Execution Plan

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
ONE-SHOT PHASE EXECUTION
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Phase: [N] - [Phase Name]

Tasks to Execute: [M]
1. [task-id-1] - [task name]
2. [task-id-2] - [task name]
3. [task-id-3] - [task name]
...

Estimated Duration: [X-Y] minutes

Execution Mode: Autonomous (continuous)
- No pauses between tasks
- Automatic commit approval
- Stop only for errors or completion

Ready to begin...
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Task Execution Loop

For each task in the queue:

### Task Start

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Starting Task [N] of [M]: [task-id] - [task name]
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Progress: [N]/[M] tasks ([X]%)
```

### Step 1: Read Context

**Read these files:**
- `memory-bank/activeContext.md` (current focus)
- `memory-bank/progress.md` (what's done/next)
- `_docs/task-list/phase-[N]-[name].md` (task details for this phase)
- `.cursor/rules/base.mdc` (core principles)
- Domain-specific rules based on files affected

**DO NOT output context reading to user** - work silently.

### Step 2: Plan Implementation (SILENTLY)

Create internal plan (do not show to user):
- Files to create/modify
- Implementation sequence
- Test strategy (write tests first)
- Risk assessment
- Memory bank updates needed

**DO NOT output plan to user** - plan autonomously.

### Step 3: Test-First Implementation

#### Write Tests FIRST (RED)
```bash
# Create/update test file
# Write failing tests that define correct behavior
npm test -- path/to/test.test.ts
# Tests should FAIL (RED) - this is expected
```

#### Implement to Pass Tests (GREEN)
```typescript
// Implement feature to pass tests
// Follow architecture patterns
// Add structured logging
// Handle edge cases
```

#### Verify All Tests Pass
```bash
npm test
# Self-correct if failures
# Retry up to 3 times
```

**CRITICAL**: Do NOT proceed to commit if tests fail after 3 attempts.

If tests fail after 3 attempts:
```
❌ TASK FAILED: [task-id]

Tests failed after 3 implementation attempts.

Errors:
[error details]

Marking task as [!] in tracker.
Halting execution.

Completed: [N-1]/[M] tasks
Remaining: [list remaining tasks]
```

### Step 4: Update Documentation

#### Update Memory Bank (If Needed)

**Conditions for update:**
- End of phase (always update)
- Major milestone within phase
- Context window reaches 90% capacity

**When updating:**
- Update `memory-bank/activeContext.md` (recent changes, current focus)
- Update `memory-bank/progress.md` (mark task complete)

**DO NOT update after EVERY task** - only when needed per conditions above.

#### Update Task Tracker (ALWAYS)

Update `_docs/task-tracker.md`:
- Mark current task as `[x]` (completed)
- Update phase progress percentage
- Update overall progress percentage
- Add completion log entry

### Step 5: Commit via Approval Workflow

Follow the complete commit approval workflow as defined in @autonomous-execution.mdc § "Commit Approval Workflow".

#### Stage Files Explicitly
```bash
git status --short
git add path/to/file1.ts path/to/file2.ts path/to/test.test.ts memory-bank/progress.md _docs/task-tracker.md
```

**FORBIDDEN**: NEVER use `git add .` or `git add -A`

#### Create Commit
```bash
git commit -m "$(cat <<'EOF'
<type>: <short description>

<detailed description>

- Key change 1
- Key change 2
- Key change 3

Task: [task-id] - [task name]
EOF
)"
```

**Commit Types:**
- `feat`: New feature
- `fix`: Bug fix
- `test`: Adding/updating tests
- `refactor`: Code refactoring
- `chore`: Maintenance (deps, config)
- `docs`: Documentation only

#### Handle Claude Review Iterations

**The pre-commit hook will trigger Claude review.** The hook is interactive and will block, returning control to the agent.

**Agent must:**
1. Analyze Claude's review feedback
2. Decide action based on feedback:
   - **Approval + no issues**: Use `AUTO_ACCEPT=true` immediately
   - **Approval + non-blocking recommendations**: Decide if significant → implement or defer
   - **Issues found**: Fix issues → request new approval
3. Iterate until approval received
4. Finalize with `AUTO_ACCEPT=true`

**Example Iteration:**

**Iteration 1:**
```bash
$ git commit -m "feat: implement feature X"
# Claude reviews: "Consider adding input validation"
# Agent decides: input validation is significant → implement
```

**Iteration 2:**
```bash
$ git commit -m "feat: implement feature X"
# Claude reviews: "✅ APPROVED - Looks good with validation"
# Agent sees approval → use AUTO_ACCEPT
```

**Final Commit:**
```bash
$ AUTO_ACCEPT=true git commit -m "feat: implement feature X"
# Bypasses interactive prompt → Commit succeeds ✅
```

**FORBIDDEN**: NEVER use `--no-verify` or `-n` flags.

#### Verify Commit
```bash
git log --oneline -1
```

### Step 6: Task Completion Report

```
Task [N] of [M] COMPLETED ✅

Task: [task-id] - [task name]
Commit: [hash] - [message]
Files: [count] changed
Tests: [count] passing

Progress: [N]/[M] tasks ([X]%)
```

### Step 7: IMMEDIATELY Continue to Next Task

**DO NOT PAUSE. DO NOT WAIT FOR USER ACKNOWLEDGMENT.**

```
Continuing to next task...
```

**Proceed directly to next task in queue.**

---

## Inter-Task Validation

Before proceeding to next task, verify:

- [ ] All tests passing (including previously passing tests)
- [ ] No uncommitted changes (commit successful)
- [ ] Memory bank updated (if condition met)
- [ ] Task tracker updated
- [ ] Git working directory clean

### ⚠️ CRITICAL: Reset Commit Approval State

**Each new task starts with NO approval.**

When moving to the next task:
- ❌ **DO NOT** use `AUTO_ACCEPT=true` on the first commit attempt
- ❌ **DO NOT** carry forward approval from previous task
- ✅ **MUST** go through full Claude review cycle for first commit
- ✅ **ONLY** use `AUTO_ACCEPT=true` after receiving approval for THIS task's commit

**Example of CORRECT behavior:**
```bash
# Task 1 completed with AUTO_ACCEPT=true ✅
# Now starting Task 2...

# ❌ WRONG: AUTO_ACCEPT=true git commit -m "feat: task 2"
# ✅ CORRECT: git commit -m "feat: task 2"  (let Claude review)
```

If ANY validation fails:
```
⚠️ INTER-TASK VALIDATION FAILED

Issue: [description]

Cannot proceed to next task.
Halting execution.
```

---

## Error Handling

### Test Failures (After 3 Retry Attempts)

```
❌ TASK FAILED: [task-id]

Tests failed after 3 attempts:
[error details]

Actions Taken:
- Marked task as [!] in tracker
- Documented failure in memory-bank/progress.md
- Updated task tracker with failure note

Completed: [N-1]/[M] tasks successfully
Remaining: [list remaining tasks]

To retry:
1. Fix the issue manually
2. Run `/one-shot Phase [N]` to resume
```

### Pre-commit Hook Failure (Non-Review)

If pre-commit hook fails for reasons OTHER than Claude review (e.g., linting, type errors):

```
❌ PRE-COMMIT HOOK FAILED

Hook Error: [error type]
Details: [error message]

This is NOT a Claude review issue.
This requires manual intervention.

Actions Taken:
- Halted execution
- Did NOT commit
- Did NOT mark task complete

Please fix the hook error and retry.
```

### Ambiguous Requirements

If task requirements are unclear:

```
⚠️ CLARIFICATION NEEDED

Task: [task-id]

Question: [specific question]

Cannot proceed without clarification.

Completed: [N-1]/[M] tasks
Remaining: [list remaining tasks]

Waiting for user response...
```

### Context Window at 90% Capacity

```
⚠️ CONTEXT CAPACITY: 90%

Pausing to compact context...

Actions:
1. Update memory bank with recent work
2. Compact context (progressive reduction)
3. Resume current task

Compacting context...
```

Follow progressive reduction from @autonomous-execution.mdc.

---

## Phase Completion Procedures

When all tasks in phase are complete:

### 1. Full Memory Bank Update

Update all relevant memory bank files:
- `memory-bank/activeContext.md` (full update)
- `memory-bank/progress.md` (mark phase complete)
- `memory-bank/systemPatterns.md` (if architecture changed)
- `memory-bank/techContext.md` (if tech stack changed)

### 2. Update Task Tracker

Update `_docs/task-tracker.md`:
- Mark all phase tasks as `[x]`
- Update phase progress to 100%
- Update overall progress percentage
- Add completion log entry with date

### 3. Generate Phase Summary

Create summary in `_context-summaries/[YYYY-MM-DD]-phase-[N]-[name].md`

Use format from example: `@_context-summaries/2025-11-11-phase1-services-implementation.md`

**Include:**
- Tasks completed
- Files changed
- Key decisions with rationale
- Non-obvious solutions (if complex/critical tasks)
- Testing approach
- Blockers resolved
- Open questions (if any)
- Next steps

**Template:**
```markdown
# Session Summary: [YYYY-MM-DD]

**Task(s)**: [task-ids]
**Duration**: ~[X] hours
**Status**: Complete

## What Was Accomplished

[Brief summary of phase work]

### Files Changed
- [list key files modified]

### Key Decisions

1. **Decision**: [what was decided]
   **Rationale**: [why]
   **Impact**: [what this affects]

2. **Decision**: [what was decided]
   **Rationale**: [why]
   **Impact**: [what this affects]

## Non-Obvious Solutions

[Only include for complex/critical tasks]

**Problem**: [what was tricky]
**Solution**: [how we solved it]
**Why this approach**: [reasoning]
**Watch out for**: [future considerations]

## Testing Approach

[Brief description of tests added/updated]
- Unit: [coverage]
- Integration: [what was tested]

## Blockers / Open Questions

[List any issues that need resolution]

## Next Steps

- [ ] Next phase or follow-up work
- [ ] Technical debt to address
- [ ] Documentation to update

## Memory Bank Updates

- [x] activeContext.md updated
- [x] progress.md updated
- [x] systemPatterns.md (if needed)
```

### 4. Report Phase Completion

```
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
PHASE [N] COMPLETED ✅
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Phase: [N] - [Phase Name]

Summary:
- Tasks: [M]/[M] completed successfully (100%)
- Commits: [M] commits created
- Files: [X] files changed
- Tests: All passing ✅

Commits Created:
- [hash1] feat: [task-1 summary]
- [hash2] feat: [task-2 summary]
- [hash3] fix: [task-3 summary]
...

Phase Summary: _context-summaries/[date]-phase-[N]-[name].md

Overall Progress: [X]/[Total] tasks ([Y]%)

Next Phase: Phase [N+1] - [Name]

Ready for review and push to remote.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

## Command Examples

### Execute Phase 1 (All Remaining Tasks)
```
User: /one-shot Phase 1

Agent executes:
1. Validates working directory clean
2. Validates tests passing
3. Identifies remaining tasks in Phase 1
4. Reports execution plan
5. Executes tasks 1.1 → 1.2 → 1.3 → ... (all remaining)
6. Generates phase summary
7. Reports completion
```

### Resume After Failure
```
Scenario: Phase 1 execution halted at task 1.3 due to test failures

User fixes issue manually
User: /one-shot Phase 1

Agent executes:
1. Sees tasks 1.1 and 1.2 are [x] (complete) → SKIP
2. Sees task 1.3 is [!] (failed) → RETRY
3. Continues with 1.3 → 1.4 → 1.5 → ... (remaining)
4. Generates phase summary (if all complete)
5. Reports completion
```

### Execute Specific Phase
```
User: /one-shot Phase 0

Agent executes Phase 0 tasks

User: /one-shot Phase 2

Agent executes Phase 2 tasks (skipping Phase 1 if specified)
```

---

## Rules & Constraints

### MANDATORY (MUST DO)

1. ✅ Validate pre-execution conditions (clean directory, tests passing)
2. ✅ Skip completed tasks (marked `[x]`)
3. ✅ Execute remaining tasks sequentially
4. ✅ Write tests FIRST (TDD)
5. ✅ Verify all tests pass before committing
6. ✅ Handle Claude review iterations automatically
7. ✅ Use `AUTO_ACCEPT=true` only after approval with no changes
8. ✅ Stage files explicitly (list all file paths)
9. ✅ Update task tracker after each task
10. ✅ IMMEDIATELY continue to next task (NO PAUSE)
11. ✅ Generate phase summary at completion
12. ✅ Full memory bank update at phase completion
13. ✅ Report progress clearly

### FORBIDDEN (MUST NOT DO)

1. ❌ Use `git add .` or `git add -A`
2. ❌ Use `--no-verify` or `-n` flags
3. ❌ Use `AUTO_ACCEPT=true` without approval
4. ❌ Use `AUTO_ACCEPT=true` after making changes post-approval
5. ❌ Use `AUTO_ACCEPT=true` on first commit of NEW task (carry forward approval from previous task)
6. ❌ Commit failing tests
7. ❌ Skip test writing
8. ❌ Pause between successful task completions
9. ❌ Wait for user acknowledgment between tasks
10. ❌ Show plans to user (plan silently)
11. ❌ Continue after 3 failed retry attempts
12. ❌ Modify files outside task scope
13. ❌ Auto-push to remote
14. ❌ Ignore ambiguous requirements
15. ❌ Update memory bank after EVERY task (only when needed)

---

## Differences from Other Commands

### `/one-shot Phase N` vs `/batch [tasks]`

**Similarities:**
- Both execute multiple tasks autonomously
- Both follow same commit approval workflow
- Both operate in autonomous mode

**Differences:**
- `/one-shot Phase N`: Executes ALL remaining tasks in specified phase
- `/batch [tasks]`: Executes specific list of tasks (e.g., `/batch 1.1 1.2 1.3`)

**Use `/one-shot Phase N` when:**
- You want to complete an entire phase
- You don't want to specify individual task IDs
- You want automatic phase summary at completion

**Use `/batch [tasks]` when:**
- You want to execute specific tasks (not necessarily a full phase)
- You want more granular control over which tasks to execute
- Tasks span multiple phases

### `/one-shot Phase N` vs `/task [id]`

**Differences:**
- `/one-shot Phase N`: Executes ALL remaining tasks in a phase (multiple tasks)
- `/task [id]`: Executes ONE specific task (single task)

**Use `/one-shot Phase N` when:**
- Completing an entire phase

**Use `/task [id]` when:**
- Executing a single well-defined task

---

## Recovery & Troubleshooting

### "Working directory not clean"
**Solution**: Commit or stash changes, then retry

### "Tests currently failing"
**Solution**: Fix failing tests, then retry

### "Task failed after 3 attempts"
**Solution**:
1. Review error details
2. Fix issue manually
3. Run `/one-shot Phase [N]` to resume (will retry failed task)

### "Pre-commit hook failed (non-review)"
**Solution**:
1. Fix linting/type errors manually
2. Retry commit manually or via command

### "Ambiguous requirements"
**Solution**:
1. Answer clarifying questions
2. Execution will resume automatically after answer

### "Context window at 90%"
**Action**: Agent automatically compacts context and resumes

---

## Safety Guarantees

The one-shot phase execution maintains these guarantees:

✅ **All code reviewed** - Every commit goes through Claude review
✅ **All tests pass** - No commits with failing tests
✅ **No secrets committed** - Safety checks before every commit
✅ **Memory bank stays current** - Updated at milestones and phase completion
✅ **Clear audit trail** - Task tracker, commits, phase summary
✅ **Can resume after interruption** - Failed tasks can be retried
✅ **User can intervene** - Execution stops for errors, ambiguity
✅ **Quality maintained** - Follows all architecture patterns and rules

---

## Notes

- This command is designed for **velocity with safety**
- The agent moves quickly but never bypasses quality gates
- For exploratory or risky work, use manual workflow (`/plan` → `/implement` → `/commit`)
- For critical infrastructure changes, consider reviewing plans before autonomous execution

---

**Remember**: Autonomous mode is about continuous execution, not rushed execution. Quality gates (tests, review, validation) are always enforced.
