# Code Review

You are tasked with reviewing code changes before they are committed. Use the code-reviewer agent and synthesize findings.

## Initial Response

```
I'll review the current changes.

Checking git status...
```

Run `git status` and `git diff` to identify changes.

## Process

### Step 1: Identify Scope

```
Changes to review:
- `path/to/file.ext` ([N] lines changed)
- `path/to/file.ext` ([N] lines changed)

[N] files changed, [N] insertions, [N] deletions

Beginning review...
```

### Step 2: Spawn Review Agent

Use the **code-reviewer** agent to analyze the changes.

### Step 3: Synthesize and Report

```
## Code Review Summary

### Status: [approved/changes-requested]

### Files Reviewed
[List of files]

### Issues Found

#### Critical (must fix)
- `file.ext:line` - [Issue]

#### Important (should fix)
- `file.ext:line` - [Issue]

#### Minor (consider fixing)
- `file.ext:line` - [Issue]

### What's Good
- [Positive observation]

### Recommendation
[Approve and commit / Address issues first]
```

### Step 4: Next Steps

If approved:
```
Ready to commit. Suggested commit message:

[type]: [description]

[body if needed]

Shall I commit with this message?
```

If changes requested:
```
Please address the issues above before committing.

Would you like me to help fix any of these issues?
```

## Review Checklist

The reviewer checks:
- [ ] Logic correctness
- [ ] Security vulnerabilities
- [ ] Error handling
- [ ] Pattern consistency
- [ ] Test coverage
- [ ] No unintended side effects
