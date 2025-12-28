# Begin Development Command

Start or resume a development session with automatic first-session detection.

## Usage

```
/begin-development
```

## Process

### Step 1: Environment Verification

```bash
pwd
git status
```

Verify working directory and git state.

### Step 2: Session Type Detection

Check `memory-bank/feature-list.json`:

**Case 1: File does NOT exist**
→ First session: Run initialization flow

**Case 2: File exists but is invalid/empty/malformed**
→ Error state: Report and request intervention
```
ERROR: feature-list.json exists but is invalid

Issue: [specific problem - empty file / invalid JSON / missing features array / empty features array]

Action Required: Please fix or remove memory-bank/feature-list.json
```

**Case 3: File exists and is valid**
→ Continuing session: Run startup protocol

### Step 3a: First Session Flow

1. **Check for projectContext.md**
   - If `memory-bank/projectContext.md` exists and is non-empty: Read for project understanding
   - If missing or empty:
     ```
     INITIALIZATION REQUIRED

     memory-bank/projectContext.md is missing or empty.

     Please provide:
     1. Project overview (what is this?)
     2. Problem statement (what problem does it solve?)
     3. Technical stack (language, framework, database)
     4. Core requirements (key features)

     You can:
     - Describe the project now and I will create projectContext.md
     - Create memory-bank/projectContext.md manually and run /begin-development again
     ```
     STOP and wait for user input.

2. **Gather additional requirements** if projectContext.md is incomplete
   - Check for missing sections (Target Users, Success Criteria, Constraints)
   - Ask clarifying questions if critical information is absent

3. **Create feature-list.json** with MVP features:
   - Use JSON schema from templates
   - Features must have testable acceptance criteria
   - Organize by phases (1.x for MVP, 2.x for post-MVP)

4. **Create remaining memory bank files** if missing:
   - activeContext.md
   - systemPatterns.md
   - techContext.md

5. **Create _docs directory structure** if missing:
   - _docs/exploration/
   - _docs/specs/
   - _docs/adrs/

6. **Create init.sh** if project requires dev server

7. **Commit initialization artifacts:**
   ```bash
   git add memory-bank/ _docs/ scripts/
   git commit --no-verify -m "chore: initialize V2 scaffold"
   ```

8. Proceed to feature selection

### Step 3b: Continuing Session Flow

1. Read memory-bank/activeContext.md for session state
2. Read memory-bank/feature-list.json for feature status
3. Check for uncommitted work:
   ```bash
   git status
   git stash list
   ```
4. If uncommitted work exists: Report and ask how to proceed
5. Run init.sh if it exists (start dev server)
6. Verify environment is functional
7. Proceed to feature selection

### Step 4: Feature Selection

From feature-list.json, find first feature where:
- `passes: false`
- All `blockedBy` features have `passes: true`
- Not marked `deprecated: true`

### Step 5: Report Ready State

```
SESSION READY

Environment:
- Working Directory: [path]
- Branch: [branch name]
- Session Type: [First Session / Continuing Session]
- Dev Server: [Running / Not configured / Failed - see error]

Status:
- Uncommitted Changes: [None / List files]
- Tests: [All passing / X failing / Not run]
- Last Session: [Summary from activeContext.md or "N/A"]

Current Focus:
- Feature: [id] - [description]
- Dependencies: [Completed list or "None"]
- Blockers: [Any blocking issues or "None"]

Ready Commands:
- /plan [feature-id] - Create implementation plan
- /implement [feature-id] - Start implementation
- /map [target] - Explore codebase
```

## Error Handling

**Environment Errors:**
- Wrong directory: Report and provide instructions
- Git not initialized: Report and suggest `git init`
- Missing dependencies: Report which and how to install

**Startup Errors:**
- init.sh fails: Report error, continue without dev server
- Tests fail: Report failures, ask whether to proceed

**State Errors:**
- Corrupted feature-list.json: Do NOT proceed, request fix
- Missing memory bank files: Create from templates
- Merge conflicts: Report and request resolution

## Constraints

- Do NOT proceed with coding if startup fails
- Do NOT auto-fix corrupted state files
- Always report clear status before proceeding
