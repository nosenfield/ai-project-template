# Implement Task Command

You are implementing a task with an existing approved plan.

## Prerequisites

1. **Verify plan approved**: Ensure human has approved the implementation plan
2. **Review plan details**: Understand all steps and constraints

## Implementation Process

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

### 5. Report Completion

**Completion format**:
```
✅ TASK COMPLETED

Task: [task-id]
Files Changed:
- [list files]

Testing:
- All tests passing ✅
- Coverage: [X%]

Acceptance Criteria:
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
