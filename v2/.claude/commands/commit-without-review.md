# Commit Without Review Command

Commit staged changes directly, bypassing the pre-commit review hook. Use for small, low-risk changes or when review is not needed.

## Usage

```
/commit-without-review <message>
```

## Arguments

- `message`: Required commit message

## Process

1. **Pre-flight Checks**
   ```bash
   git diff --staged --stat
   ```
   - Count lines changed
   - Count files changed

2. **Risk Assessment**
   - If >50 lines changed: WARN and suggest /commit-with-approval
   - If >3 files changed: WARN and suggest /commit-with-approval
   - If includes test files only: Low risk
   - If includes critical paths: WARN

3. **Execute Commit** (bypasses pre-commit hook)
   ```bash
   git commit --no-verify -m "[message]"
   ```

4. **Report**

## Constraints

- Message is REQUIRED (no auto-generation)
- Warnings for larger changes
- No blocking (user override allowed)
- Bypasses all pre-commit hooks including review

## Output Format

```
## Direct Commit (No Review)

### Changes
[file list with stats]

### Risk Assessment
[LOW - proceeding]
[MEDIUM - consider using /commit-with-approval]
[HIGH - strongly recommend /commit-with-approval]

### Commit
- Hash: [commit hash]
- Message: [message]
- Review: SKIPPED (--no-verify)
```
