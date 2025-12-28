# Batch Command

Execute multiple features or an entire phase using subagent delegation.

## Usage

```
/batch <feature-ids...> | Phase <N>
```

## Arguments

- `feature-ids...`: Space-separated list of feature IDs (e.g., `1.1 1.2 1.3`)
- `Phase N`: Execute all features in phase N (e.g., `Phase 1`)

## Process

1. **Parse Input**
   - If feature IDs: Validate each exists in feature-list.json
   - If Phase N: Extract all features with ID prefix `N.`

2. **Dependency Resolution**
   - Order features by dependencies (blockedBy)
   - Verify no circular dependencies
   - Report execution order

3. **Sequential Execution**
   For each feature in order:

   a. **Check Preconditions**
      - All blockedBy features have `passes: true`
      - No uncommitted changes from previous feature

   b. **Delegate to Subagents**
      - Use planner subagent for /plan if needed
      - Use implementer subagent for /implement
      - Pre-commit hook handles review at commit time

   c. **Verify Completion**
      - All tests pass
      - Pre-commit review approved
      - Feature marked `passes: true`

   d. **Commit**
      - Stage changes
      - Commit with feature reference (triggers pre-commit hook)
      - Update activeContext.md

   e. **Continue or Stop**
      - On success: Proceed to next feature
      - On failure: Stop batch, report status

4. **Report Summary**

## Constraints

- Stop on first failure (no partial features)
- Each feature must pass pre-commit review
- Commit after each feature (not at end of batch)
- Update memory bank after each feature

## Output Format

```
## Batch Execution: [Feature list or Phase N]

### Execution Plan
| Order | Feature | Description | Dependencies |
|-------|---------|-------------|--------------|
| 1 | [id] | [desc] | [deps] |
| 2 | [id] | [desc] | [deps] |

### Progress

#### Feature [id]: [description]
- Status: [COMPLETE / FAILED / IN PROGRESS]
- Plan: [Created / Skipped]
- Implementation: [Complete / Failed at step X]
- Review: [Approved / Issues found]
- Commit: [hash or N/A]

[Repeat for each feature]

### Summary
- Total Features: [N]
- Completed: [X]
- Failed: [Y]
- Remaining: [Z]

### Next Steps
[If complete: "Batch complete. Run /begin-development for next batch."]
[If failed: "Batch stopped at [feature]. Fix issues and run /batch [remaining] to continue."]
```

## Error Handling

If feature fails:
1. Stop batch immediately
2. Preserve partial state
3. Document failure point
4. Provide recovery instructions

If subagent fails:
1. Retry once with increased verbosity
2. If still fails: Stop and report
3. Suggest manual intervention
