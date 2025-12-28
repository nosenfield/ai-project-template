# Advance Stage Command

Move to the next pipeline stage after completing current stage requirements.

## Usage

```
/advance-stage
```

## Process

1. Read current stage from _docs/pipeline-state.json
2. Verify exit conditions for current stage:
   - READY_FOR_SPEC → Specification complete
   - READY_FOR_ARCH → ADR produced
   - READY_FOR_BUILD → Implementation complete, tests passing
   - READY_FOR_REVIEW → Review approved
3. If conditions met: Advance to next stage
4. If conditions not met: Report what's missing

## Output Format

```
## Stage Transition

### From: [current stage]
Exit Conditions:
- [x] [condition 1]
- [x] [condition 2]

### To: [next stage]
Entry Requirements:
- [requirement 1]
- [requirement 2]

### Status
[ADVANCED - now at [stage]]
[BLOCKED - missing: [conditions]]
```
