# Fix Tests Command

Tests are failing. Execute self-correcting loop.

## Process

### 1. Run Test Suite

```bash
npm test
# Or specific test command for this project
```

### 2. Analyze Failures

**Read error messages carefully**:
- What test failed?
- What was expected?
- What was actual?
- What is the root cause (not just symptom)?

### 3. Identify Root Cause

**Ask yourself**:
- Is the test correct? (tests define requirements)
- Is the implementation wrong?
- Is there a logic error?
- Is there an edge case not handled?

### 4. Propose Fix

**Show diff before applying**:
```
I found the issue: [description]

Root cause: [explain why it failed]

Proposed fix:
[show code diff]

Reasoning: [why this fix is correct]
```

### 5. Apply Fix

After user approval, apply the fix.

### 6. Run Tests Again

```bash
npm test
```

### 7. Repeat Until Green

**REPEAT steps 2-6 until ALL tests pass**

## Important Rules

### DO NOT:
- ❌ Modify tests to make them pass
- ❌ Skip failing tests
- ❌ Commit with failing tests
- ❌ Give up after one attempt

### DO:
- ✅ Analyze failures carefully
- ✅ Fix root cause, not symptoms
- ✅ Explain your reasoning
- ✅ Show diffs before applying
- ✅ Verify tests pass after fix
- ✅ Repeat until all green

## Success Criteria

All tests pass ✅
