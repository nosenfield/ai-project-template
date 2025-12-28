# Pause Command

Save session state for clean handoff or session end.

## Usage

```
/pause [--handoff]
```

## Arguments

- `--handoff`: Include detailed handoff information for another agent/developer

## Process

1. **Capture Current State**
   - Current feature in progress
   - Implementation status
   - Uncommitted changes
   - Failing tests (if any)
   - Open questions

2. **Update Memory Bank**
   - Update activeContext.md with session state
   - Include timestamp
   - Include branch name

3. **Git Status**
   - Report uncommitted changes
   - Suggest stash if needed

4. **Generate Handoff** (if --handoff)
   - Detailed context for next session
   - What was attempted
   - What worked/didn't work
   - Recommended next steps

## Output Format

```
## Session Paused

### Current State
- Feature: [id] - [description]
- Progress: [X of Y steps complete]
- Branch: [branch name]
- Uncommitted Changes: [count files]

### Session Summary
[Brief summary of work done this session]

### Open Items
- [Item 1]
- [Item 2]

### Memory Bank Updated
- activeContext.md: [Updated with session state]

### Resume Instructions
Run `/begin-development` to resume this session.

[If --handoff:]
### Handoff Notes
[Detailed context for next developer/agent]

#### What Was Done
[List of completed work]

#### What's In Progress
[Current state of incomplete work]

#### Known Issues
[Any problems encountered]

#### Recommended Next Steps
1. [Step 1]
2. [Step 2]
```
