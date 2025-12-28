# AUTO_ACCEPT Quick Reference

## The Simple Rule

```
First commit attempt  = git commit -m "message"          (NO AUTO_ACCEPT)
                       ↓
                    Claude reviews
                       ↓
                  Gets "APPROVED"
                       ↓
Second commit attempt = AUTO_ACCEPT=true git commit -m "message"  (YES AUTO_ACCEPT)
```

## Decision Matrix

| Scenario | Use AUTO_ACCEPT? | Command |
|----------|------------------|---------|
| First commit attempt | ❌ NO | `git commit -m "..."` |
| After receiving "APPROVED" | ✅ YES | `AUTO_ACCEPT=true git commit -m "..."` |
| After receiving "ISSUES FOUND" | ❌ NO | Fix issues, then `git commit -m "..."` |
| After making ANY changes | ❌ NO | `git commit -m "..."` |
| After AUTO_ACCEPT violation | ❌ NO | `git commit -m "..."` |
| Starting new task | ❌ NO | `git commit -m "..."` |

## Common Violations & Fixes

### Violation 1: AUTO_ACCEPT_ON_FIRST_ATTEMPT
```bash
# ❌ What you did:
AUTO_ACCEPT=true git commit -m "feat: add feature"

# ✅ What to do:
git commit -m "feat: add feature"
```

### Violation 2: AUTO_ACCEPT_WITHOUT_APPROVAL
```bash
# ❌ What you did:
git commit -m "..."           # Claude says "ISSUES FOUND"
AUTO_ACCEPT=true git commit -m "..."  # Violation!

# ✅ What to do:
git commit -m "..."           # Claude says "ISSUES FOUND"
# Fix issues...
git add fixed-files.ts
git commit -m "..."           # Get new approval
AUTO_ACCEPT=true git commit -m "..."  # Now OK
```

### Violation 3: AUTO_ACCEPT_WITH_MODIFIED_CONTENT
```bash
# ❌ What you did:
git commit -m "..."           # Claude says "APPROVED - add JSDoc"
# Implement JSDoc...
git add updated-file.ts
AUTO_ACCEPT=true git commit -m "..."  # Violation!

# ✅ What to do:
git commit -m "..."           # Claude says "APPROVED - add JSDoc"
# Implement JSDoc...
git add updated-file.ts
git commit -m "..."           # Get NEW approval
AUTO_ACCEPT=true git commit -m "..."  # Now OK
```

## If You Get a Violation

**STOP** using AUTO_ACCEPT immediately and retry WITHOUT it:

```bash
# You saw this error:
⚠️  AUTO_ACCEPT VIOLATION DETECTED

# Your next command MUST be:
git commit -m "same message as before"

# NOT:
AUTO_ACCEPT=true git commit -m "..."  # Will fail again!
```

## Remember

**AUTO_ACCEPT is not a shortcut. It's only for retrying an already-approved commit.**
