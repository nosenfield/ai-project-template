# Git Commit Command

You are helping the user create a git commit with proper staging and commit message formatting.

## Important Rules

1. **NEVER use `git add .` or `git add -A`** - Always stage files individually by name
2. **Always list files explicitly** - Show the user what will be committed
3. **Create meaningful commit messages** - Follow conventional commit format
4. **Include Claude Code attribution** - Add the footer to all commits

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

### Step 2: List Changed Files

Present to the user:
```
Files ready to commit:

Modified:
  - file1.ts
  - file2.tsx

New:
  - file3.ts

Deleted:
  - file4.ts

Total: X files
```

### Step 3: Stage Files Individually

For each file to be committed, run:
```bash
git add path/to/file1.ts
git add path/to/file2.tsx
git add path/to/file3.ts
```

**NEVER run `git add .` or `git add -A`**

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
feat: Add database schema for sessions table

Implement Drizzle ORM schema for tracking tutoring sessions:
- SessionData interface with all required fields
- Timestamps for join/leave times
- Rating and feedback fields
- Indexing strategy for common queries
```

```
chore: Update dependencies to latest versions

- Upgrade Next.js to 16.0.1
- Update React to 19.2.0
- Install @supabase/ssr for Next.js 16 compatibility
```

### Step 5: Create Commit

Run the commit command using heredoc for proper formatting:

```bash
git commit -m "$(cat <<'EOF'
<commit message here>
EOF
)"
```

### Step 6: Verify Commit

After committing:
1. Show the commit hash and message
2. Run `git log --oneline -1` to verify
3. Ask if user wants to push to remote

## Safety Checks

Before committing, verify:
- [ ] No `.env` or `.env.local` files being committed (unless it's `.env.example`)
- [ ] No `node_modules/` being committed
- [ ] No large binary files (> 10MB) unless intentional
- [ ] No API keys or secrets in code
- [ ] Files are actually ready to commit (not work-in-progress)

If any safety issues found, warn the user and ask for confirmation.

## Special Cases

### Case 1: Committing .env.example
✅ Allowed - This is a template file

### Case 2: Committing package-lock.json or pnpm-lock.yaml
✅ Allowed - These are dependency lockfiles

### Case 3: Committing Memory Bank updates
Use commit type: `docs: Update Memory Bank - <what changed>`

### Case 4: Large refactoring (10+ files)
Break into multiple commits if possible, or ask user if they want one commit.

## Example Session

```
User: /commit