# One-Shot Task Command (Single Task)

Execute a **single task** from planning through commit in one flow.

**Scope**: This command executes ONE task (e.g., `/task 1.3`). For executing entire phases, use `/one-shot Phase N`.

**Use this when**:
- Executing a well-defined single task
- You trust the AI to execute without intermediate approvals
- You want velocity for one specific task

**Use `/one-shot Phase N` when**:
- Executing all remaining tasks in a phase
- Want to complete an entire phase autonomously

**Use plan → implement → commit when**:
- You need to review plans or implementation steps before proceeding
- Requirements are ambiguous or risky

## Mode
This command can operate in **manual** or **autonomous** mode depending on context. For autonomous behavior details, see @autonomous-execution.mdc.

---

## Workflow Overview

This command performs the 3-step process automatically:
1. **Plan** (plan equivalent)
2. **Implement** (implement equivalent)
3. **Commit** (commit equivalent)

---

## Step 1: Read Context

**Memory Bank**:
- memory-bank/activeContext.md (current focus)
- memory-bank/progress.md (completed tasks)

**Task Details**:
- _docs/task-list.md (find specified task-id)

**Rules**:
- .cursor/rules/base.mdc
- Domain-specific rules for affected files

---

## Step 2: Silent Planning

Create an internal execution plan (don't output to user unless they ask):

**Files to modify**:
- List files with glob patterns
- Note purpose for each file

**Implementation steps**:
- Sequence of changes
- Test-first approach

**Risk assessment**:
- Identify potential issues
- Plan mitigations

---

## Step 3: Test-First Implementation

### Write Tests FIRST

```
1. Create/update test files
2. Write failing tests (RED) - define correct behavior
3. Ensure tests can run (even if failing)
```

### Implement to Pass Tests

```
1. Touch ONLY planned files
2. Follow architecture patterns from _docs/architecture.md
3. Add structured logging (use src/utils/logger.py)
4. Handle edge cases
5. NO cross-module refactoring
```

### Verify Green

```bash
npm test
# OR
pytest

# Self-correct if failures
# Iterate until all green
```

**CRITICAL**: Do NOT proceed to commit until ALL tests pass.

---

## Step 4: Update Documentation

### Memory Bank Updates

**activeContext.md**:
- Update "Current Focus" section
- Add to "Recent Changes" (most recent at top)
- Update "Next Steps"
- Note any new blockers/questions
- Update "Key Files Currently Modified"

**progress.md**:
- Mark task as completed with date
- Add to "What's Working" section
- Note verification steps completed
- Update "What's Next" priorities

---

## Step 5: Commit Changes

### Safety Checks

Before committing, verify:
- [ ] No `.env` or credentials files (unless `.env.example`)
- [ ] No `node_modules/` or `__pycache__/`
- [ ] No large binaries (> 10MB) unless intentional
- [ ] No API keys or secrets in code
- [ ] All tests passing ✅

### Git Workflow

```bash
# Check status
git status --short

# Stage files explicitly (NEVER use git add . or git add -A)
git add path/to/file1.py path/to/file2.py path/to/file3.py

# Commit with conventional format
git commit -m "$(cat <<'EOF'
<type>: <short description>

<detailed description if needed>

<succinct list of key changes>
EOF
)"

# Verify
git log --oneline -1
```

### Commit Message Format

```
<type>: <short description>

<detailed description>

- Key change 1
- Key change 2
- Key change 3
```

**Types**:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only
- `test`: Adding/updating tests
- `refactor`: Code refactoring
- `chore`: Maintenance (deps, config)
- `perf`: Performance improvements

---

## Step 6: Report Completion

```
✅ TASK COMPLETED

Task: [task-id] - [task name]

Files Changed:
- path/to/file1.py
- path/to/file2.py
- memory-bank/activeContext.md
- memory-bank/progress.md

Testing:
- All tests passing ✅
- New tests: [count]
- Coverage: [X%] (if available)

Acceptance Criteria:
- [x] Criterion 1
- [x] Criterion 2
- [x] Criterion 3

Commit: [commit hash]
Ready for push: Yes
```

---

## Rules & Constraints

### MUST DO

1. ✅ Read memory bank first
2. ✅ Write tests before implementation
3. ✅ Verify all tests pass before committing
4. ✅ Update memory bank documentation
5. ✅ Stage files explicitly (no `git add .`)
6. ✅ Use conventional commit format
7. ✅ Report completion with checklist

### MUST NOT DO

1. ❌ Commit with failing tests
2. ❌ Skip test writing
3. ❌ Touch files outside planned scope
4. ❌ Use `git add .` or `git add -A`
5. ❌ Use `--no-verify` or `-n` (must run pre-commit hooks)
6. ❌ Commit secrets or credentials
7. ❌ Cross-module refactoring
8. ❌ Auto-push to remote

---

## Example Execution

**User**: `/one-shot 0.3`

**AI executes**:

1. Reads memory bank + task-list.md for Task 0.3
2. Silently plans implementation (config.py)
3. Creates test file: tests/unit/utils/test_config.py
4. Writes failing tests for config functionality
5. Implements src/utils/config.py to pass tests
6. Runs pytest - verifies all green ✅
7. Updates memory-bank/activeContext.md
8. Updates memory-bank/progress.md
9. Stages: src/utils/config.py, tests/unit/utils/test_config.py, memory-bank/*.md
10. Commits: "feat: Implement configuration management system"
11. Reports completion with checklist

**Total time**: 2-5 minutes (vs 10-15 with approval gates)

---

## When to Use vs Standard Workflow

### Use `/one-shot` when:
- Task is well-defined in task-list.md
- You trust AI to execute correctly
- You want maximum velocity
- Task is relatively self-contained

### Use `/plan` → `/implement` → `/commit` when:
- Task requirements are ambiguous
- You want to review the plan first
- Implementation involves risky changes
- You're working on critical infrastructure
- You want to learn the AI's approach

---

## Recovery from Failures

If tests fail after multiple attempts:
1. Stop execution
2. Report failure with error details
3. Ask user for guidance
4. Do NOT commit failing code

If unclear requirements discovered:
1. Stop execution
2. Ask clarifying questions
3. Wait for user response
4. Resume from planning step
