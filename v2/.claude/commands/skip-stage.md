# Skip Stage Command

Skip an optional pipeline stage with justification.

## Usage

```
/skip-stage <stage> --reason <justification>
```

## Arguments

- `stage`: Stage to skip (SPEC or ARCH only - BUILD and REVIEW are required)
- `--reason`: Required justification for skipping

## Process

1. Verify stage is skippable (SPEC or ARCH only)
2. Record skip with justification in pipeline history
3. Advance to next stage

## Constraints

- Cannot skip BUILD or REVIEW stages
- Must provide justification
- Skip is recorded in history for audit

## Output Format

```
## Stage Skipped

### Skipped: [stage]
Reason: [justification]

### Advanced To: [next stage]

### Audit Record
Recorded in pipeline-state.json history
```
