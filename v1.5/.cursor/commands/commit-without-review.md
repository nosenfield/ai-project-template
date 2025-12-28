# Commit Without Review

Commit staged changes with explicit permission to bypass Claude code review.

**Use this when**: You need to commit non-code files or administrative changes that don't require code review (memory bank updates, documentation, logs, meta files).

---

## Important Rules

1. **NEVER use `git add .` or `git add -A`** - Always stage files with explicit paths
2. **NEVER commit files containing secrets** - Check for .env, credentials, API keys
3. **Always list files explicitly** - Show the user what will be committed
4. **Follow conventional commit format** - Same as normal commits
5. **Add bypass marker** - Include `[skip-review]` in commit message

---

## Workflow

### Step 1: Check Git Status

Run:
```bash
git status --short
```

Show the user:
- Modified files
- Untracked files
- Currently staged files

### Step 2: Identify Files to Commit

Based on the user's context and the changes, determine which files should be committed.

**Common bypass scenarios:**
- `memory-bank/**` - Memory bank updates
- `_docs/**` - Documentation updates
- `_logs/**` - Log files
- `*.md` - Markdown documentation
- Configuration or meta files

### Step 3: Show Diff

Run:
```bash
git diff --cached
```

If no files staged yet, show what will be staged:
```bash
git diff <files>
```

### Step 4: Stage Files Explicitly

**REQUIRED**: Stage files one by one or list all explicitly:

```bash
git add path/to/file1.md path/to/file2.json memory-bank/activeContext.md
```

**FORBIDDEN**: Never use:
- `git add .`
- `git add -A`
- `git add --all`

### Step 5: Safety Checks

Before committing, verify:

1. **No secrets or credentials**
   - Check for: `.env`, `credentials.json`, API keys, tokens
   - If found: **STOP** and warn the user

2. **No large files** (> 10MB unless intentional)
   - Run: `git diff --cached --stat`
   - Warn if suspiciously large

3. **No unintended files**
   - No `node_modules/`, `__pycache__/`, `.DS_Store`
   - No build artifacts unless explicitly intended

### Step 6: Create Commit Message

Follow conventional commit format with `[skip-review]` marker:

```
<type>: <short description> [skip-review]

<detailed description>

- Key change 1
- Key change 2

Bypassed code review: <reason>
```

**Types:** `docs`, `chore`, `refactor`, `feat`, `fix`

**Reason examples:**
- "non-code files (memory bank update)"
- "documentation only"
- "administrative files"
- "log files"

**Example:**
```
docs: update memory bank with latest context [skip-review]

Updated activeContext.md and progress.md to reflect completed tasks
and current development focus.

- Updated active context with new patterns
- Marked tasks 0.3-0.4 as complete
- Added notes on best practices implementation

Bypassed code review: non-code files (memory bank update)
```

### Step 7: Commit with -n Flag

Execute:
```bash
git commit -n -m "$(cat <<'EOF'
<commit message here>
EOF
)"
```

The `-n` flag bypasses the pre-commit hook (Claude review).

### Step 8: Verify Commit

Run:
```bash
git log --oneline -1
```

Show the user:
- Commit hash
- Commit message
- Confirmation that commit succeeded

---

## Post-Commit Logging

The post-commit hook will log this as a bypassed commit. The log entry will show:

```
⚠️  COMMIT: <hash> | Files: X | BYPASSED PRE-COMMIT | <message>
```

The `[skip-review]` marker in the commit message distinguishes this as an **authorized bypass** (not a violation).

---

## Example Execution

**User**: `/commit-without-review`

**AI Response**:

```
Running git status...

Modified files:
  M  memory-bank/activeContext.md
  M  memory-bank/progress.md

Staged files:
  M  memory-bank/activeContext.md
  M  memory-bank/progress.md

Showing diff of staged changes...

[Shows git diff --cached output]

Safety checks:
✓ No secrets detected
✓ No large files
✓ No unintended files

Creating commit with bypass permission...

git commit -n -m "docs: update memory bank with latest context [skip-review]

Updated activeContext.md and progress.md to reflect completed tasks
and current development focus.

- Updated active context with new patterns
- Marked tasks 0.3-0.4 as complete
- Added notes on best practices implementation

Bypassed code review: non-code files (memory bank update)"

Commit created: a1b2c3d docs: update memory bank with latest context [skip-review]

Note: This commit bypassed Claude code review as authorized.
The bypass is logged in _logs/commit-bypasses.log with [skip-review] marker.
```

---

## Rules & Constraints

### MUST DO

1. ✅ Show git status before committing
2. ✅ Show git diff --cached
3. ✅ Stage files with explicit paths
4. ✅ Check for secrets/credentials
5. ✅ Check for large files
6. ✅ Use conventional commit format
7. ✅ Add `[skip-review]` marker to commit message
8. ✅ Add "Bypassed code review: <reason>" to commit body
9. ✅ Use `-n` flag to bypass pre-commit hook
10. ✅ Verify commit succeeded

### MUST NOT DO

1. ❌ Use `git add .` or `git add -A`
2. ❌ Commit secrets or credentials
3. ❌ Skip safety checks
4. ❌ Omit `[skip-review]` marker
5. ❌ Omit bypass reason in commit body
6. ❌ Use this for code changes (use normal commit workflow)
7. ❌ Auto-push to remote

---

## When to Use vs Normal Commit

### Use `/commit-without-review` when:
- Committing memory-bank files
- Committing documentation only
- Committing log files or reports
- Committing configuration/meta files
- User explicitly requests bypass

### Use normal commit workflow when:
- Committing code (any programming language)
- Committing tests
- Committing build configurations
- Committing anything that affects runtime behavior

---

## Logging Details

### Commit Message Format
The `[skip-review]` marker in the subject line indicates authorized bypass:
```
docs: update memory bank [skip-review]
```

### Post-Commit Log Entry
Will appear in `_logs/commit-bypasses.log` as:
```
═══════════════════════════════════════════════════════════════
PRE-COMMIT HOOK BYPASSED
═══════════════════════════════════════════════════════════════
Timestamp:       2025-11-14T10:30:00Z
Commit Hash:     a1b2c3d
Author:          User Name <user@example.com>
Files Changed:   2
Commit Message:  docs: update memory bank [skip-review]

Details:
  This commit was created with --no-verify or -n flag
  Pre-commit hook (Claude code review) was not executed

Files Modified:
  - memory-bank/activeContext.md
  - memory-bank/progress.md

═══════════════════════════════════════════════════════════════
```

The audit script (`scripts/audit-commits.sh`) can distinguish between:
- **Authorized bypasses**: Commits with `[skip-review]` in message
- **Violations**: Commits without `[skip-review]` marker

---

**Remember**: This command grants explicit one-time permission to bypass review. Use it responsibly for non-code changes only.
