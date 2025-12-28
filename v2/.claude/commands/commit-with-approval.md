# Commit With Approval Command

Stage and commit changes. Pre-commit hook provides review gate.

## Usage

```
/commit-with-approval [message]
```

## Arguments

- `message`: Optional commit message (auto-generated if not provided)

## Process

1. **Pre-flight Checks**
   ```bash
   git status
   git diff --staged --stat
   ```
   - Verify there are staged changes
   - List files to be committed

2. **Optional Early Review**
   - If concerned about changes, run /review first for early feedback
   - Address any issues before attempting commit

3. **Generate Commit Message** (if not provided)
   - Analyze changes
   - Follow conventional commits format
   - Include feature ID if applicable

4. **Execute Commit**
   ```bash
   git commit -m "[message]"
   ```
   - Pre-commit hook runs Claude CLI code review
   - If hook rejects: Report issues, commit fails
   - If hook approves: Commit succeeds

5. **Post-Commit**
   - Report commit hash
   - Update activeContext.md if feature completed
   - Update feature-list.json if feature passes

## Constraints

- Pre-commit hook provides mandatory review gate
- Commit messages must follow conventional commits
- Do not use --no-verify (use /commit-without-review for that)

## Output Format

```
## Commit Attempt

### Changes Staged
[file list with stats]

### Commit Message
[generated or provided message]

### Pre-Commit Review
[Hook output - APPROVED or REJECTED with issues]

### Result
[SUCCESS - Commit hash: abc123]
[FAILED - Address issues above and retry]

### Post-Commit Status
- Feature [id]: [Still in progress / Marked complete]
- Memory Bank: [Updated / No update needed]
```

## Error Handling

If no staged changes:
1. Report "Nothing to commit"
2. Suggest `git add` commands

If pre-commit hook rejects:
1. Display review issues from hook
2. Do NOT retry automatically
3. Instruct user to fix issues and retry
