# Git Commit Command (With Pre-commit Hook Approval)

You are helping the user create a git commit with proper staging and commit message formatting. This command requires approval from pre-commit hooks before finalizing the commit.

## Important Rules

1. **NEVER use `git add .` or `git add -A`** - Always stage files with explicit paths
2. **Always list files explicitly** - Show the user what will be committed
3. **Use a single `git add` command** - List all files in one command, not multiple individual commands
4. **Create meaningful commit messages** - Follow conventional commit format
5. **ALWAYS run pre-commit hooks** - Never use `--no-verify` or `-n`
6. **Handle hook feedback** - If hooks fail, fix issues or provide reasoning

---

## Workflow

### Step 1: Check Git Status

Run:
```bash
git status --short
```

Analyze the output and categorize files:
- Modified files (M)
- New files (??)
- Deleted files (D)
- Renamed files (R)

---

### Step 2: List Changed Files

Present to the user:
```
Files ready to commit:

Modified:
  - file1.py
  - file2.py

New:
  - file3.py

Deleted:
  - file4.py

Total: X files
```

---

### Step 3: Stage Files in Single Command

Stage all files in a single `git add` command with explicit file paths:
```bash
git add path/to/file1.py path/to/file2.py path/to/file3.py
```

**Important:**
- Use a single `git add` command listing all files explicitly
- **NEVER run `git add .` or `git add -A`** - This would stage everything including untracked files
- The single command approach reduces noise while maintaining explicit control over what gets staged

---

### Step 4: Draft Commit Message

Follow this format:

```
<type>: <short description>

<detailed description if needed>

<succinct list of key changes>
```

**Commit Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks (dependencies, config, etc.)
- `perf`: Performance improvements

**Examples:**

```
feat: Implement configuration management system

Add Pydantic-based configuration with environment support:
- Multi-environment support (dev, staging, prod)
- Type-safe configuration loading
- Helper methods for DynamoDB and AWS endpoints
```

```
chore: Update dependencies to latest versions

- Upgrade pytest to 8.0.0
- Update black to 24.0.0
- Add pydantic-settings for config management
```

---

### Step 5: Safety Checks

Before committing, verify:
- [ ] No `.env` or `.env.local` files being committed (unless it's `.env.example`)
- [ ] No `node_modules/` or `__pycache__/` being committed
- [ ] No large binary files (> 10MB) unless intentional
- [ ] No API keys or secrets in code
- [ ] Files are actually ready to commit (not work-in-progress)

If any safety issues found, warn the user and ask for confirmation.

---

### Step 6: Attempt Commit (Let Hooks Run)

Run the commit command using heredoc for proper formatting:

```bash
git commit -m "$(cat <<'EOF'
<commit message here>
EOF
)"
```

**CRITICAL**: Do NOT use `--no-verify` or `-n`. Pre-commit hooks MUST run.

The hooks will check:
- Code formatting (black, prettier, etc.)
- Linting (ruff, eslint, etc.)
- Type checking (mypy, tsc, etc.)
- Tests passing
- Security checks

---

### Step 7: Analyze Hook Response

After attempting commit, analyze the result:

#### Case A: Hooks Pass - Commit Successful ✅

If hooks pass and commit succeeds:

```
✅ COMMIT SUCCESSFUL

Pre-commit hooks: PASSED

Commit: a1b2c3d feat: Implement configuration management system
Files: 3 files changed, 45 insertions(+), 2 deletions(-)

You can verify with: git log --oneline -1
```

**Done!** No further action needed.

---

#### Case B: Hooks Auto-Fixed Files 🔧

If hooks modified files (e.g., black reformatted code):

```
⚠️ PRE-COMMIT HOOKS MODIFIED FILES

The following files were auto-fixed:
  - src/utils/config.py (formatted by black)
  - src/utils/logger.py (formatted by black)

The commit was NOT created yet.

I will now:
1. Review the changes made by hooks
2. Stage the modified files
3. Retry the commit
```

**Action Steps:**

1. **Show what changed:**
```bash
git diff
```

2. **Explain the changes:**
```
Changes made by pre-commit hooks:
- black reformatted code (whitespace, line breaks)
- No logic changes, only formatting
```

3. **Stage the auto-fixed files:**
```bash
git add path/to/file1.py path/to/file2.py
```

4. **Retry commit:**
```bash
git commit -m "$(cat <<'EOF'
<same commit message>
EOF
)"
```

5. **Report success:**
```
✅ COMMIT SUCCESSFUL (after auto-fixes)

Pre-commit hooks: PASSED (on retry)

Commit: a1b2c3d feat: Implement configuration management system
Files: 3 files changed, 47 insertions(+), 2 deletions(-)
```

---

#### Case C: Hooks Fail - Validation Errors ❌

If hooks fail with validation errors:

```
❌ PRE-COMMIT HOOKS FAILED

Hook: black
Error: File src/utils/config.py has syntax errors

Details:
  src/utils/config.py:42:15: E999 SyntaxError: invalid syntax

The commit was NOT created.
```

**Action Steps:**

1. **Analyze the error:**
   - Is it a syntax error? → Must fix
   - Is it a linting issue? → Must fix
   - Is it a type error? → Must fix
   - Is it a test failure? → Must fix

2. **Attempt to fix automatically:**

If the error is clear and fixable:
```
I will fix the syntax error in src/utils/config.py:42

The issue: Missing closing parenthesis
Fix: Add closing parenthesis

Applying fix...
```

3. **Verify the fix:**
```bash
# Re-run the specific hook that failed
black src/utils/config.py
```

4. **Stage fixed files and retry:**
```bash
git add src/utils/config.py
git commit -m "$(cat <<'EOF'
<same commit message>
EOF
)"
```

5. **If fix successful:**
```
✅ COMMIT SUCCESSFUL (after fixes)

Pre-commit hooks: PASSED (after fixing syntax error)

Commit: a1b2c3d feat: Implement configuration management system
```

---

#### Case D: Hooks Fail - Cannot Auto-Fix ⚠️

If the error cannot be fixed automatically:

```
❌ PRE-COMMIT HOOKS FAILED

Hook: mypy
Error: Type checking failed

Details:
  src/utils/config.py:42: error: Incompatible types in assignment (expression has type "str", variable has type "int")
  src/utils/logger.py:15: error: Missing return statement

The commit was NOT created.

REASONING WHY I CANNOT AUTO-FIX:

1. Type error at line 42:
   - The code assigns a string to an integer variable
   - This requires understanding the intended logic
   - Auto-fixing could introduce bugs
   - Recommendation: Review the code and correct the type

2. Missing return statement at line 15:
   - The function is declared to return a value but doesn't
   - This requires understanding the function's purpose
   - Auto-fixing could break functionality
   - Recommendation: Add appropriate return statement

SUGGESTED ACTIONS:

1. Review src/utils/config.py:42 and fix type mismatch
2. Add return statement to function in src/utils/logger.py:15
3. Run 'mypy src/utils/' to verify fixes
4. Re-run commit command

Would you like me to:
- Show the problematic code? (git diff)
- Explain the type error in detail?
- Suggest a potential fix (with explanation)?
```

**Reasoning Format:**

When cannot auto-fix, provide:
1. **What failed:** Specific error from hook
2. **Why cannot fix:** Reasoning for each error
3. **Risk of auto-fixing:** What could go wrong
4. **Recommended action:** What user should do

---

### Step 8: Verify Commit

After successful commit:

```bash
git log --oneline -1
git show --stat
```

Show:
- Commit hash and message
- Files changed
- Insertions/deletions count

---

## Auto-Fix Decision Matrix

| Hook Type | Error Type | Auto-Fix? | Reasoning |
|-----------|------------|-----------|-----------|
| black | Formatting | ✅ Yes | Safe, deterministic |
| ruff | Import sorting | ✅ Yes | Safe, deterministic |
| ruff | Unused imports | ✅ Yes | Safe to remove |
| mypy | Type errors | ❌ No | Requires logic understanding |
| pytest | Test failures | ❌ No | Requires logic fixes |
| eslint | Syntax errors | ❌ No | Could break functionality |
| Custom hook | Validation | ⚠️ Maybe | Depends on error |

**Rules for Auto-Fixing:**

✅ **Can auto-fix when:**
- Error is purely formatting (whitespace, line breaks)
- Fix is deterministic (same result every time)
- Fix cannot introduce bugs
- Hook provides the fix (e.g., black reformats)

❌ **Cannot auto-fix when:**
- Error requires logic understanding
- Multiple valid solutions exist
- Fix could introduce bugs
- Error is in tests or test logic
- Type system errors
- Requires human judgment

---

## Retry Strategy

After fixing issues:

1. **Stage fixed files:**
```bash
git add <files that were fixed>
```

2. **Retry commit with SAME message:**
```bash
git commit -m "$(cat <<'EOF'
<same commit message as before>
EOF
)"
```

3. **Maximum 3 retry attempts:**
   - Attempt 1: Original commit
   - Attempt 2: After auto-fixes
   - Attempt 3: After manual intervention

After 3 failed attempts:
```
❌ COMMIT FAILED AFTER 3 ATTEMPTS

Pre-commit hooks continue to fail.

The issues require manual intervention:
[List of remaining issues]

Suggested workflow:
1. Fix the issues manually
2. Run 'git add <files>'
3. Run 'git commit' manually
4. Or: Use '/commit' command again after fixes
```

---

## Special Cases

### Case 1: Hooks Disabled or Not Installed

If no hooks are configured:

```
⚠️ WARNING: No pre-commit hooks detected

Installing pre-commit hooks is recommended for code quality.

To install: pre-commit install

Proceeding with commit anyway...
```

### Case 2: Hook Timeout

If hook takes too long (> 60 seconds):

```
⚠️ PRE-COMMIT HOOK TIMEOUT

Hook 'pytest' exceeded 60 second timeout.

Options:
1. Wait longer (continue waiting)
2. Skip this hook (not recommended)
3. Cancel commit

Recommendation: Optimize tests or run separately
```

### Case 3: Partial Hook Failure

If some hooks pass, some fail:

```
MIXED PRE-COMMIT RESULTS

Passed:
✅ black - Code formatting
✅ ruff - Import sorting

Failed:
❌ mypy - Type checking (3 errors)

The commit was NOT created due to failures.

Fixing mypy errors...
[Attempt to fix or explain why cannot fix]
```

---

## Example Full Execution

### Example 1: Success on First Try

**User**: `/commit-with-approval`

**AI**:
```
Checking git status...

Files ready to commit:
- src/utils/config.py
- tests/unit/utils/test_config.py

Staging files...
git add src/utils/config.py tests/unit/utils/test_config.py

Creating commit...
git commit -m "$(cat <<'EOF'
feat: Implement configuration management system

Add Pydantic-based configuration with environment support:
- Multi-environment support (dev, staging, prod)
- Type-safe configuration loading
EOF
)"

Running pre-commit hooks...
[black]..........Passed
[ruff]............Passed
[mypy]............Passed

✅ COMMIT SUCCESSFUL

Commit: a1b2c3d feat: Implement configuration management system
Files: 2 files changed, 45 insertions(+), 0 deletions(-)
```

---

### Example 2: Auto-Fix and Retry

**User**: `/commit-with-approval`

**AI**:
```
Checking git status...
Staging files...
Creating commit...

Running pre-commit hooks...
[black]..........Failed
- hook id: black
- files were modified by this hook

⚠️ FILES MODIFIED BY PRE-COMMIT HOOKS

Auto-fixed by black:
- src/utils/config.py (formatting)

Changes made:
- Reformatted to 88 character line width
- Fixed whitespace

Staging auto-fixed files...
git add src/utils/config.py

Retrying commit...
git commit -m "..."

Running pre-commit hooks...
[black]..........Passed
[ruff]............Passed
[mypy]............Passed

✅ COMMIT SUCCESSFUL (after auto-fixes)

Commit: a1b2c3d feat: Implement configuration management system
```

---

### Example 3: Cannot Auto-Fix

**User**: `/commit-with-approval`

**AI**:
```
Checking git status...
Staging files...
Creating commit...

Running pre-commit hooks...
[mypy]............Failed
- hook id: mypy

src/utils/config.py:42: error: Incompatible types in assignment

❌ COMMIT FAILED

REASONING WHY I CANNOT AUTO-FIX:

The mypy error indicates a type mismatch at line 42:
```python
age: int = "25"  # Error: str assigned to int
```

I cannot auto-fix this because:
1. Multiple solutions exist:
   - Convert string to int: age = int("25")
   - Change type to str: age: str = "25"
   - Fix the source of the string value

2. Each solution has different implications:
   - Conversion could raise ValueError if not a valid number
   - Changing type might break other code expecting int
   - Fixing source requires understanding data flow

3. This requires understanding the intended logic

RECOMMENDED ACTION:

Review line 42 and choose the appropriate fix:
- If age should be int: age = int("25")
- If age can be str: age: str = "25"

Then re-run the commit command.

Would you like me to show the problematic code?
```

---

## Rules & Constraints

### MUST DO

1. ✅ Stage files explicitly by name
2. ✅ Draft proper commit message
3. ✅ Run commit with hooks (no --no-verify)
4. ✅ Analyze hook response
5. ✅ Auto-fix if safe and possible
6. ✅ Provide reasoning if cannot fix
7. ✅ Retry after fixes
8. ✅ Report final status clearly

### MUST NOT DO

1. ❌ Use `git add .` or `git add -A`
2. ❌ Use `--no-verify` or `-n`
3. ❌ Auto-fix type errors or logic errors
4. ❌ Auto-fix without understanding the change
5. ❌ Ignore hook failures
6. ❌ Retry indefinitely (max 3 attempts)
7. ❌ Commit with failing hooks

---

**Remember**: The pre-commit hooks are the gatekeepers. If they fail, either fix the issues safely or explain why manual intervention is needed. Never bypass the hooks.
