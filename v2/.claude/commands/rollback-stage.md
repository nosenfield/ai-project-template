# Rollback Stage Command

Return to a previous pipeline stage.

## Usage

```
/rollback-stage [target-stage]
```

## Arguments

- `target-stage`: Optional specific stage to return to (default: previous stage)

## Process

1. Identify current and target stages
2. Record rollback in history with reason
3. Update current stage

## Output Format

```
## Stage Rollback

### From: [current stage]
### To: [target stage]

### Reason
[Reason for rollback if provided]

### Impact
- [What work may need to be redone]

### Next Steps
[What to do in the target stage]
```
