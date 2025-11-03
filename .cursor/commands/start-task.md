# Start Task Command

You are starting a new task.

## Steps

1. **Read Memory Bank**:
   - memory-bank/activeContext.md
   - memory-bank/progress.md

2. **Read task**: _docs/task-list.md (find the specified task-id)

3. **Read relevant rules**:
   - .cursor/rules/base.mdc
   - Load domain-specific rules based on files affected

4. **Produce PLAN**:
   - Files to touch (with globs)
   - Implementation steps
   - Test plan (unit/integration/e2e)
   - Acceptance criteria checklist
   - Risk analysis
   - Memory bank updates needed

5. **Show plan and WAIT for approval before implementing.**

## Output Format

```markdown
## Plan for Task: [task-id]

### Files to Modify
- `path/to/file1.ts` - [purpose]
- `path/to/file2.ts` - [purpose]

### Implementation Steps
1. [Step 1]
2. [Step 2]
3. [Step 3]

### Test Plan
**Unit Tests**:
- [ ] Test A
- [ ] Test B

**Integration Tests**:
- [ ] Test X

### Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2

### Risk Analysis
- **Risk 1**: [description] → [mitigation]
- **Risk 2**: [description] → [mitigation]

### Memory Bank Updates
- [ ] Update activeContext.md (current focus)
- [ ] Update progress.md (mark in progress)
```

## Approval Gate

**WAIT FOR USER APPROVAL** before proceeding with implementation.
