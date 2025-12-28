# Plan Command

You are planning a new task.

## Steps

1. **Read Memory Bank**:
   - memory-bank/activeContext.md
   - memory-bank/progress.md

2. **Read task**: _docs/task-list.md (find the specified task-id)

3. **Read relevant rules**:
   - .cursor/rules/base.mdc
   - .cursor/rules/subagent-delegation.mdc
   - Load domain-specific rules based on files affected

4. **Assess Exploration Need** (V1.5):

   **Delegate to EXPLORER subagent if:**
   - Affected files are unknown
   - Task spans multiple modules
   - Exploration would require >5 file reads

   **Execute directly if:**
   - Files to modify are already known
   - Task is confined to 1-2 known files

   ```
   IF delegation needed:
     → Delegate to explorer subagent with:
       - Target: [feature/system to explore]
       - Depth: medium
       - Context: Task [task-id], planning purpose
     → Receive exploration summary (1-2K tokens)
     → Use summary for planning (do NOT re-read explored files)
   ```

5. **Produce PLAN**:
   - Files to touch (from exploration summary or direct knowledge)
   - Implementation steps
   - Test plan (unit/integration/e2e)
   - Acceptance criteria checklist
   - Risk analysis (include risks from exploration)
   - Memory bank updates needed
   - **Delegation recommendation**: Should implementation be delegated?

6. **Show plan and WAIT for approval before implementing.**

## Exploration Delegation Format

When delegating to explorer:

```markdown
**Exploration Request**

Target: [feature/system/pattern related to task]
Depth: medium

Context:
- Task: [task-id] - [task description]
- Purpose: Planning implementation approach

Questions to Answer:
- What files need to be modified for this task?
- What existing patterns should be followed?
- What dependencies or integrations are involved?
- Are there existing tests to reference?
```

## Output Format

```markdown
## Plan for Task: [task-id]

### Exploration Summary
[If explorer was used, include key findings here]
[If direct: "Files identified from existing context"]

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

### Implementation Delegation (V1.5)
**Recommendation**: [DELEGATE / DIRECT]
**Rationale**: [Why delegate or execute directly]
- Estimated lines of change: [X]
- Files affected: [Y]
- Threshold: >50 lines OR >3 files → delegate

### Memory Bank Updates
- [ ] Update activeContext.md (current focus)
- [ ] Update progress.md (mark in progress)
```

## Delegation Decision Tree

```
Task received
    │
    ├─► Are affected files known?
    │       │
    │       NO ──► Delegate to EXPLORER
    │              └─► Receive summary
    │              └─► Use summary (don't re-read files)
    │       │
    │       YES ──► Continue directly
    │
    └─► Produce plan with delegation recommendation
```

## Approval Gate

**WAIT FOR USER APPROVAL** before proceeding with implementation.

When user approves:
- If delegation recommended: Use `/implement` which will delegate to implementer
- If direct recommended: Use `/implement` which will execute directly
