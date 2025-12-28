# Pipeline Status Command

Display current pipeline state for complex task execution.

## Usage

```
/pipeline-status
```

## Process

1. Read _docs/pipeline-state.json
2. Display current stage and history
3. Show available transitions

## Output Format

```
## Pipeline Status

### Current State
- Stage: [IDLE / READY_FOR_SPEC / READY_FOR_ARCH / READY_FOR_BUILD / READY_FOR_REVIEW / DONE]
- Task: [task-id or "None"]
- Pipeline: [Enabled / Disabled]

### Stage Progress
[x] SPEC - [Complete / Skipped / Pending]
[x] ARCH - [Complete / Skipped / Pending]
[ ] BUILD - [In Progress / Pending]
[ ] REVIEW - [Pending]
[ ] DONE - [Pending]

### Available Commands
- /advance-stage - [available / blocked: reason]
- /skip-stage [stage] - [available stages]
- /rollback-stage - [available / at beginning]

### History
| Timestamp | Stage | Outcome |
|-----------|-------|---------|
| [time] | [stage] | [outcome] |
```
