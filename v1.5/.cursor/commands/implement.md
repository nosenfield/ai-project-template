# Implement Task Command

You are implementing a task with an existing approved plan.

## Prerequisites

1. **Verify plan approved**: Ensure human has approved the implementation plan
2. **Review plan details**: Understand all steps and constraints
3. **Check delegation recommendation**: Was DELEGATE or DIRECT recommended?

## Delegation Assessment (V1.5)

Before implementing, assess whether to delegate to the implementer subagent:

**Delegate to IMPLEMENTER subagent if:**
- Implementation exceeds 50 lines of changes
- Changes span 3 or more files
- Complex refactoring within scope
- Plan recommended DELEGATE

**Execute directly if:**
- Simple edits under 50 lines
- Changes confined to 1-2 files
- Plan recommended DIRECT
- Quick fix with known solution

```
IF delegation threshold met:
  → Delegate to implementer subagent
  → Provide: task requirements, exploration summary, file paths, constraints
  → Receive implementation summary (2-3K tokens)
  → Verify: status COMPLETE, tests passing, ready for commit
  → Proceed to commit workflow

IF direct execution:
  → Execute TDD workflow directly (steps below)
  → Report completion
  → Proceed to commit workflow
```

## Implementer Delegation Format

When delegating to implementer:

```markdown
**Implementation Request**

Task: [task-id] - [task description]

Requirements:
- [Requirement 1 from plan]
- [Requirement 2 from plan]

Exploration Summary:
[Include exploration summary from /plan if available]

Files to Modify:
- `path/to/file1.ts` - [what to change]
- `path/to/file2.ts` - [what to change]

Test Requirements:
- [Test scenario 1]
- [Test scenario 2]

Constraints:
- Touch ONLY files listed above
- Follow existing patterns from [reference]
- Do NOT commit (return changes to orchestrator)

Success Criteria:
- [Criterion 1 from plan]
- [Criterion 2 from plan]
```

## Direct Implementation Process

If NOT delegating, execute directly:

### 1. Test-First Workflow

**Write tests FIRST**:
```
- Create/update test files
- Write failing tests (RED)
- Tests define "correct" behavior
```

### 2. Implement to Pass Tests

**Implementation**:
- Touch ONLY files in approved plan
- Follow architecture patterns
- Add structured logging
- Handle edge cases
- NO refactoring across module boundaries

### 3. Verify Tests Pass

**Run verification**:
```bash
npm test
# Self-correct if failures
# Repeat until all green
```

### 4. Update Documentation

**Memory Bank updates**:
- memory-bank/activeContext.md (current state)
- memory-bank/progress.md (mark task progress)

## Handling Implementer Results

When implementer subagent returns:

**If Status: COMPLETE**
```
→ Review files changed
→ Verify test results (should be passing)
→ Check "Ready for Commit: YES"
→ Proceed to commit workflow
```

**If Status: PARTIAL**
```
→ Review what was completed
→ Review what remains
→ Decide: complete manually OR report to user
→ If completing manually: stay within scope
```

**If Status: FAILED**
```
→ Review failure details
→ Review what was tried
→ Report to user with diagnosis
→ Wait for guidance before retrying
```

## Report Completion

### If Delegated

```markdown
✅ TASK COMPLETED (via implementer subagent)

Task: [task-id]

### Implementation Summary
[Paste key points from implementer's summary]

### Files Changed
| File | Action | Lines |
|------|--------|-------|
| [from summary] | [action] | [lines] |

### Testing
- All tests passing ✅
- New tests added: [count]

### Acceptance Criteria
- [x] Criterion 1
- [x] Criterion 2

Ready for commit: Yes
```

### If Direct

```markdown
✅ TASK COMPLETED (direct implementation)

Task: [task-id]

### Files Changed
- [list files with descriptions]

### Testing
- All tests passing ✅
- Coverage: [X%]

### Acceptance Criteria
- [x] Criterion 1
- [x] Criterion 2

Ready for commit: Yes
```

## Rules

- Touch ONLY files in approved plan
- Commit ONLY when tests green
- Prefer additive changes
- Use feature flags for risky changes
- WAIT for approval before committing
- **V1.5**: Respect delegation thresholds to preserve context
- **V1.5**: Use implementer summary, do NOT re-read implemented files

## Delegation Decision Tree

```
/implement [task-id]
    │
    ├─► Check plan's delegation recommendation
    │
    ├─► Assess: >50 lines OR >3 files?
    │       │
    │       YES ──► Delegate to IMPLEMENTER
    │              │
    │              ├─► Receive summary
    │              ├─► Verify COMPLETE status
    │              └─► Proceed to commit
    │       │
    │       NO ──► Execute DIRECTLY
    │              │
    │              ├─► TDD workflow
    │              ├─► Verify tests pass
    │              └─► Report completion
    │
    └─► WAIT for commit approval
```
