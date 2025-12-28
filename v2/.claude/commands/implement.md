# Implement Command

Implement a feature or task by creating and editing files, including tests.

## Usage

```
/implement <feature-id|task> [--plan] [--no-review]
```

## Arguments

- `feature-id|task`: Feature ID from feature-list.json OR specific task description
- `--plan`: Create plan first before implementing (runs /plan internally)
- `--no-review`: Skip early feedback review (pre-commit hook still applies)

## Process

1. **Preparation**
   - If feature-id: Read feature from feature-list.json, check blockedBy
   - If `--plan` specified: Run /plan first

2. **Check for Existing Plan**
   - Look for `_docs/specs/{feature-id}.md`
   - If found: Read and follow implementation sequence
   - If not found and `--plan` not specified: Assess scope
     - If complex (>3 files, cross-module): Recommend running /plan first
     - If simple: Create minimal inline plan and proceed

3. **Exploration** (if needed)
   - Check for existing `_docs/exploration/*.md` files
   - Use /map patterns to understand affected areas
   - Identify existing patterns to follow
   - Locate test file conventions

4. **Test-Driven Development**
   - Write failing tests first
   - Tests must cover acceptance criteria
   - Run tests to confirm they fail

5. **Implementation**
   - Implement code to pass tests
   - Follow existing patterns from _docs/best-practices.md
   - Keep functions small (<50 lines)
   - Handle errors appropriately
   - Add logging for key operations

6. **Verification**
   - Run all tests (new and existing)
   - Verify no regressions
   - Manual verification if applicable

7. **Early Review** (unless --no-review)
   - Run /review on changes for early feedback
   - Address any CRITICAL issues before completing
   - Document any deferred WARNINGS

## Constraints

- Stay within scope of specified feature/task
- Do NOT refactor unrelated code
- Do NOT modify interfaces without explicit approval
- Commit nothing directly (changes staged only)

## Output Format

```
## Implementation Complete: [Feature ID or Title]

### Changes Made
| File | Action | Description |
|------|--------|-------------|
| [path] | [created/modified] | [what changed] |

### Tests Added
| Test | Verifies |
|------|----------|
| [test name] | [what it tests] |

### Verification Results
- All tests: [PASSING / FAILING with details]
- Existing tests: [PASSING / REGRESSION with details]
- Manual verification: [Done / Not needed / Required steps]

### Review Status
[SKIPPED / APPROVED / ISSUES FOUND - see review output]

### Next Steps
[Ready for commit / Issues to address / Follow-up tasks]
```

## Error Handling

If implementation fails:
1. Report specific failure point
2. Preserve working state (partial progress)
3. Document what was attempted
4. Suggest recovery approach

If tests fail:
1. Do NOT mark feature as complete
2. Analyze failure cause
3. Fix implementation or adjust test if test was incorrect
4. Re-run verification
