# Update Memory Bank Command

Synchronize memory bank files with current session state.

## Usage

```
/update-memory-bank [--full]
```

## Arguments

- `--full`: Update all memory bank files (not just activeContext.md)

## Process

1. **Always Update: activeContext.md**
   - Current session timestamp
   - Current feature focus
   - Recent changes summary
   - Open questions
   - Next steps

2. **Conditional Update: feature-list.json**
   - ONLY update `passes` field
   - ONLY if feature verification complete
   - Update `lastModified` timestamp

3. **If --full: Update Other Files**
   - systemPatterns.md: New patterns discovered
   - techContext.md: New technical decisions
   - projectContext.md: Rarely (scope changes only)

## Constraints

- NEVER remove features from feature-list.json
- NEVER edit feature descriptions (deprecate + create new instead)
- Preserve existing content, append new information

## Output Format

```
## Memory Bank Updated

### Files Updated
| File | Changes |
|------|---------|
| activeContext.md | [summary of changes] |
| feature-list.json | [features updated or "No changes"] |

### Verification
- All files valid: [YES / NO - issues]
- Git status: [Changes staged / Need to commit]
```
