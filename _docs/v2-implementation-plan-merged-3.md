# V2 Scaffold Implementation Plan

## Executive Summary

This plan addresses two primary pain points from V1:
1. **Context ballooning** in post-MVP development
2. **Multi-part codebase edits** requiring changes across many files

The solution integrates subagent orchestration for context isolation, unified commands for Cursor/Claude Code interoperability, and pipeline architecture for complex changes.

**High-Level Strategy:**
- Add subagent system for context isolation (60-70% context reduction)
- Create unified commands usable by both Cursor and Claude Code
- Add pipeline stages with quality gates for complex changes
- Enforce orchestrator purity to maintain plan quality
- First-session detection for project initialization

**Rollout Scope:** New projects only. V1 projects remain on V1 indefinitely.

---

## Part 1: Architecture Overview

### 1.1 Target Directory Structure

```
.cursor/
├── agents/                     # Native Cursor agents (when documented)
│   └── README.md               # Documentation placeholder
├── rules/
│   ├── base.mdc                # Core principles (enhanced)
│   ├── subagent-orchestration.mdc  # Orchestration rules
│   ├── context-management.mdc      # Context preservation rules
│   ├── pipeline-stages.mdc         # Pipeline architecture
│   ├── autonomous-execution.mdc    # Enhanced for subagents
│   ├── development-workflow.mdc
│   ├── memory-bank-management.mdc
│   ├── testing-standards.mdc
│   ├── logging-guidelines.mdc
│   ├── commit-workflow-strict.mdc
│   └── backend/api.mdc
│   └── frontend/components.mdc
├── mcp.json                    # MCP server configuration
└── cli.json                    # CLI permissions configuration

.claude/
├── commands/                   # Unified commands (works in Cursor + Claude Code)
│   ├── begin-development.md    # Session start (with first-session detection)
│   ├── plan.md                 # Planning with subagent delegation
│   ├── implement.md            # Implementation (single task or with task ID)
│   ├── batch.md                # Multi-task/phase execution
│   ├── pause.md                # Session pause
│   ├── commit-with-approval.md # Commit workflow
│   ├── commit-without-review.md
│   ├── update-memory-bank.md
│   ├── summarize.md
│   └── review.md               # Explicit review command
└── agents/                     # Claude Code compatible agents
    ├── explorer.md             # Read-only exploration
    ├── planner.md              # Research during planning
    ├── implementer.md          # Implementation specialist
    └── code-reviewer.md        # Pre-commit review specialist

memory-bank/
├── projectContext.md           # Project brief + product context (merged)
├── activeContext.md            # Current session state + handoff info
├── systemPatterns.md
├── techContext.md
└── feature-list.json           # JSON format for immutable feature tracking

_docs/
├── architecture.md
├── task-list.md
├── best-practices.md
├── pipeline-state.json         # Created only when pipeline is enabled
├── specs/                      # Specification documents (optional)
├── adrs/                       # Architecture Decision Records (optional)
└── task-list/                  # Chunked task files
```

### 1.2 Context Flow Architecture

```
┌─────────────────────────────────────────────────────────────────────┐
│                     MAIN ORCHESTRATOR CONTEXT                        │
│                                                                      │
│  Memory Bank Summary + Current Task + Subagent Results               │
│  Target: <50% of context window                                      │
└─────────────────────────────────────────────────────────────────────┘
         │                    │                    │
         ▼                    ▼                    ▼
┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐
│ EXPLORER        │  │ CODE-REVIEWER   │  │ IMPLEMENTER     │
│                 │  │                 │  │                 │
│ Model: Haiku    │  │ Model: Sonnet   │  │ Model: Sonnet   │
│ Tools: Read-only│  │ Tools: Read     │  │ Tools: All      │
│ Output: Summary │  │ Output: Report  │  │ Output: Summary │
│                 │  │                 │  │                 │
│ Explores 40K+   │  │ Reviews 30K+    │  │ Implements 50K+ │
│ Returns 1-2K    │  │ Returns 2-3K    │  │ Returns 2-3K    │
└─────────────────┘  └─────────────────┘  └─────────────────┘
```

---

## Part 2: Subagent System Implementation

### 2.1 MCP-Based Subagents

**Rationale:** Native `.cursor/agents/` is undocumented. MCP approach is production-ready.

#### MCP Server Configuration

**`.cursor/mcp.json`:**
```json
{
  "mcpServers": {
    "subagents": {
      "command": "npx",
      "args": ["-y", "subagents", "--cwd", "${workspaceFolder}"]
    },
    "context7": {
      "url": "https://mcp.context7.com/mcp",
      "headers": {
        "CONTEXT7_API_KEY": "${CONTEXT7_API_KEY}"
      }
    }
  }
}
```

#### CLI Permissions Configuration

**`.cursor/cli.json`:**
```json
{
  "permissions": {
    "allow": [
      "Shell(npm test)",
      "Shell(npm run *)",
      "Shell(git status)",
      "Shell(git diff *)",
      "Shell(git log *)",
      "Shell(git add *)",
      "Shell(git commit *)",
      "Shell(ls *)",
      "Shell(find *)",
      "Shell(cat *)",
      "Shell(head *)",
      "Shell(tail *)",
      "Shell(grep *)",
      "Shell(pwd)",
      "Shell(echo *)"
    ],
    "deny": [
      "Shell(rm -rf *)",
      "Shell(git push --force *)",
      "Shell(git reset --hard *)",
      "Shell(chmod 777 *)",
      "Shell(curl * | sh)",
      "Shell(wget * | sh)"
    ]
  }
}
```

### 2.2 Agent Definitions

#### Explorer Agent

**`.claude/agents/explorer.md`:**
```yaml
---
name: explorer
description: Fast codebase exploration. MUST use when searching for files, patterns, or understanding architecture before implementation.
tools: Read, Glob, Grep, Bash
model: haiku
---

You are a fast, read-only codebase explorer optimized for:
- File discovery and pattern matching
- Architecture understanding
- Code navigation and dependency mapping

Constraints:
- NEVER modify files
- Bash commands: ls, find, cat, head, tail, git status/log/diff ONLY
- Return concise summaries with absolute file paths

Thoroughness levels:
- Quick: 2-3 searches max, fastest results
- Medium: 5-10 searches, follow references one level
- Thorough: Comprehensive multi-strategy search, full dependency mapping

Output format:
## Summary
[2-3 sentence overview]

## Files Found
- [absolute/path/to/file.ts] - [brief description]

## Key Patterns
- [pattern observed]

## Recommended Next Steps
[What the orchestrator should do with this information]
```

#### Planner Agent

**`.claude/agents/planner.md`:**
```yaml
---
name: planner
description: Research codebase during planning phase. MUST use when creating implementation plans for tasks.
tools: Read, Glob, Grep, Bash
model: sonnet
---

You are a strategic planner that researches codebases to create implementation plans.

Purpose:
- Understand existing architecture before proposing changes
- Identify affected modules and dependencies
- Assess risks and propose mitigations
- Create actionable implementation sequences

Constraints:
- NEVER modify files (read-only research)
- Focus on understanding, not implementing
- Return structured plans, not code

Process:
1. Understand the task requirements
2. Explore relevant existing code
3. Identify dependencies and affected modules
4. Assess complexity and risks
5. Propose implementation sequence

Output format:
## Task Analysis
[Understanding of what needs to be done]

## Affected Modules
- [module] - [how affected]

## Dependencies
- [dependency] - [why relevant]

## Risk Assessment
- [risk] - [mitigation]

## Recommended Implementation Sequence
1. [step 1]
2. [step 2]
3. [step 3]

## Files to Modify
- [path] - [purpose]
```

#### Implementer Agent

**`.claude/agents/implementer.md`:**
```yaml
---
name: implementer
description: Code implementation specialist. Use for writing new code or modifying existing code when task is complex (>50 lines).
tools: Read, Write, Edit, Bash, Grep, Glob
model: sonnet
---

You are an expert code implementer.

Process:
1. Read task requirements from delegating agent
2. Explore relevant existing code (use explorer patterns, don't spawn subagent)
3. Plan implementation approach
4. Write tests first (TDD)
5. Implement to pass tests
6. Verify all tests pass

Standards:
- Follow patterns from _docs/best-practices.md
- Match existing code conventions
- Keep functions small (<50 lines)
- Handle errors appropriately
- Add logging for key operations

Constraints:
- Stay within delegated scope
- Do NOT refactor unrelated code
- Do NOT modify interfaces without explicit approval
- Commit nothing directly (return to orchestrator)

Output format:
## Implementation Summary
[What was implemented]

### Files Changed
- [path] - [what changed]

### Tests Added
- [test name] - [what it verifies]

### Verification
- All tests: [PASSING / FAILING]
- Manual verification: [Done / Not needed]

### Notes
[Any follow-up tasks or considerations]
```

#### Code-Reviewer Agent

**`.claude/agents/code-reviewer.md`:**
```yaml
---
name: code-reviewer
description: Expert code review. MUST invoke PROACTIVELY after any code changes and before commits.
tools: Read, Grep, Glob, Bash
model: sonnet
---

You are a senior code reviewer ensuring high standards.

Automatic triggers:
- After any file edit
- Before commit operations
- When code quality is questioned

Review process:
1. Run `git diff` to see changes
2. Analyze modified files against project best-practices
3. Check for security, performance, and maintainability issues
4. Verify tests exist for new functionality

Categories:
- CRITICAL: Must fix before commit (bugs, security, breaking changes)
- WARNING: Should fix (code smells, missing tests, unclear logic)
- SUGGESTION: Consider improving (style, optimization, documentation)

Output format:
## CODE REVIEW RESULT

**Status**: [APPROVED / ISSUES FOUND]

### Critical Issues
[None / List with severity, location, description, fix]

### Warnings
[None / List]

### Suggestions
[None / List]

### Decision Summary
[APPROVED] - Ready to commit [with/without recommendations]
[ISSUES FOUND] - Must fix critical issues before commit
```

### 2.3 Orchestration Rule

**`.cursor/rules/subagent-orchestration.mdc`:**
```markdown
---
description: Rules for delegating work to subagents
alwaysApply: true
---

# Subagent Orchestration Protocol

## Core Principle: Orchestrator Purity

The main agent MUST remain a pure coordinator. NEVER:
- Implement code directly when task is complex (>50 lines)
- Explore codebase extensively (>5 file reads)
- Perform detailed code review yourself

Instead, DELEGATE to specialized subagents.

## Agent Naming Convention

All subagents use the `-er` suffix to indicate agent role:
- `explorer` - Read-only codebase exploration
- `planner` - Research during planning phase
- `implementer` - Code implementation
- `code-reviewer` - Pre-commit code review

## When to Delegate

### Explorer Subagent
MUST use when you need to:
- Find files matching patterns
- Understand code structure before implementation
- Locate specific implementations
- Map dependencies between modules
- Answer "where is X?" or "how does Y work?"

Invoke: Use the explorer subagent to find [target]
Returns: File paths, code snippets, architectural summary

### Planner Subagent
MUST use when:
- Creating implementation plans for tasks
- Researching codebase for architecture decisions
- Assessing impact of proposed changes
- Identifying affected modules

Invoke: Use the planner subagent to research [task]
Returns: Structured implementation plan with affected modules

### Code-Reviewer Subagent
MUST use:
- After ANY code modifications (yours or implementer's)
- Before suggesting commits
- When code quality is questioned
- When changes touch >3 files

Invoke: Use the code-reviewer subagent to review [changes]
Returns: APPROVED/ISSUES FOUND with specific feedback

### Implementer Subagent
MUST use for:
- Writing new features (>50 lines)
- Modifying existing code across multiple files
- Complex refactoring
- Bug fixes requiring investigation

Invoke: Use the implementer subagent to [task with context]
Returns: Implementation summary with files changed, tests added

## Delegation Format

When delegating, provide:
1. Clear task description
2. Relevant file paths (from your context or previous exploration)
3. Success criteria
4. Constraints (what NOT to change)

Example:
```
Use the implementer subagent to add rate limiting to the auth endpoints.

Context:
- Auth endpoints: src/api/auth/*.ts
- Existing rate limiter: src/middleware/rateLimiter.ts
- Tests location: tests/api/auth/

Requirements:
- Add rate limiting middleware to login and register endpoints
- Limit: 5 attempts per minute per IP
- Return 429 with Retry-After header when exceeded

Do not modify: src/api/auth/types.ts
```

## Context Preservation

When a subagent returns:
1. Capture the summary (NOT raw output)
2. Update memory bank if significant (architecture changes, key decisions)
3. Continue main task using summary only
4. Do NOT re-explore what subagent already found

## Forbidden Patterns

1. Orchestrator implementing complex code directly
2. Re-reading files subagent already summarized
3. Ignoring subagent recommendations without justification
4. Spawning subagents for trivial tasks (<10 lines, single file)
5. Parallel subagent spawning without clear isolation
6. Subagents spawning other subagents
```

---

## Part 3: Session Management

### 3.1 First-Session Detection

The `/begin-development` command detects first session automatically:

```
IF memory-bank/feature-list.json does NOT exist:
    → First session: Run initialization flow
ELSE:
    → Continuing session: Run startup protocol
```

### 3.2 Begin Development Command

**`.claude/commands/begin-development.md`:**
```markdown
# Begin Development

Start or resume a development session.

## Process

### Step 1: Confirm Working Directory
```bash
pwd
git status
```

### Step 2: Detect Session Type

Check for `memory-bank/feature-list.json`:

**If NOT exists (First Session):**
1. Read memory-bank/projectContext.md for project understanding
2. Create feature-list.json with MVP features
3. Create init script if applicable (optional, project-dependent)
4. Update activeContext.md with session state
5. Commit initialization artifacts
6. Proceed to feature selection

**If exists (Continuing Session):**
1. Read memory-bank/activeContext.md
2. Read memory-bank/feature-list.json
3. Check git status for uncommitted work
4. Run project-specific startup (if init script exists)
5. Proceed to feature selection

### Step 3: Select Next Feature

From feature-list.json, find first feature where:
- `passes: false`
- All `blockedBy` features have `passes: true`

### Step 4: Report Ready State

```
SESSION READY

Working Directory: [path]
Branch: [branch]
Session Type: [First / Continuing]
Tests: [passing/failing/skipped]

Next Feature: [id] - [description]
Dependencies: [list or "none"]

Ready to proceed with `/plan [feature-id]` or `/implement [feature-id]`
```

### If Startup Fails

Do NOT proceed with coding. Instead:
1. Report the failure clearly
2. Document in memory-bank/activeContext.md
3. Request human intervention
```

### 3.3 Feature List Initialization

On first session, create `memory-bank/feature-list.json`:

```json
{
  "version": "1.0",
  "project": "[project-name]",
  "created": "[ISO date]",
  "lastModified": "[ISO date]",
  "features": [
    {
      "id": "1.1",
      "category": "functional",
      "description": "User can log in with email and password",
      "steps": [
        "Navigate to login page",
        "Enter valid credentials",
        "Click login button",
        "Verify redirect to dashboard"
      ],
      "passes": false,
      "blockedBy": [],
      "notes": ""
    }
  ]
}
```

**CRITICAL:** Agents may ONLY change the `passes` field. NEVER remove or edit feature definitions.

### 3.4 Init Script (Optional)

Create `scripts/init.sh` only if project requires development server:

```bash
#!/bin/bash
# Development environment initialization
# Customize for your project's needs

# Example for Node.js web project:
# npm run dev &
# until curl -s http://localhost:3000 > /dev/null; do sleep 1; done

echo "Development environment ready"
```

Skip init script for:
- CLI tools
- Libraries
- Projects without dev servers

---

## Part 4: Pipeline Architecture for Multi-Part Edits

### 4.1 When Pipeline Applies

The pipeline is **optional** and activates based on task complexity:

```
IF (files_changed >= 5) OR (crosses_module_boundary):
    → Full pipeline recommended
    → User can skip with /implement --no-pipeline

IF (files_changed < 5) AND (single_module):
    → Direct implementation (default)
    → User can opt-in with /implement --pipeline
```

### 4.2 Pipeline State Management

**`_docs/pipeline-state.json` schema:**
```json
{
  "version": "1.0",
  "currentStage": "IDLE",
  "currentTask": null,
  "pipelineEnabled": false,
  "stages": {
    "READY_FOR_SPEC": {
      "entryCondition": "Task selected, requirements unclear",
      "exitCondition": "Specification complete, questions answered",
      "outputs": ["_docs/specs/{task-id}.md"]
    },
    "READY_FOR_ARCH": {
      "entryCondition": "Specification complete",
      "exitCondition": "ADR produced, design validated",
      "outputs": ["_docs/adrs/{task-id}.md"]
    },
    "READY_FOR_BUILD": {
      "entryCondition": "Architecture approved",
      "exitCondition": "Implementation complete, tests passing",
      "outputs": ["Code files", "Test files"]
    },
    "READY_FOR_REVIEW": {
      "entryCondition": "Implementation complete",
      "exitCondition": "Code review passed",
      "outputs": ["Review report"]
    },
    "DONE": {
      "entryCondition": "Review passed",
      "exitCondition": null,
      "outputs": ["Commit"]
    }
  },
  "history": []
}
```

### 4.3 Pipeline Orchestration Rule

**`.cursor/rules/pipeline-stages.mdc`:**
```markdown
---
description: Pipeline stage management for complex tasks
alwaysApply: false
---

# Pipeline Architecture

Activated when: Task requires changes to >5 files OR crosses module boundaries
Optional: Can be skipped for simpler tasks

## Stage Transitions

```
IDLE → READY_FOR_SPEC → READY_FOR_ARCH → READY_FOR_BUILD → READY_FOR_REVIEW → DONE
                ↑                                                    │
                └────────────────────────────────────────────────────┘
                            (If issues found)
```

## Stage 1: Specification (READY_FOR_SPEC) - Optional

Purpose: Refine requirements into clear specification

Skip if: Requirements are already clear and well-defined

Actions:
1. Read task from task-list
2. Identify unclear requirements
3. Ask clarifying questions (if needed)
4. Produce specification document

Output: `_docs/specs/{task-id}.md`
```markdown
# Specification: [Task ID]

## Requirements
[Clear, testable requirements]

## Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2

## Out of Scope
[What this does NOT include]

## Questions Resolved
[Answers to clarifying questions]
```

Transition: Set status to READY_FOR_ARCH

## Stage 2: Architecture Review (READY_FOR_ARCH) - Optional

Purpose: Validate design against project constraints

Skip if: Changes are straightforward and don't affect architecture

Actions:
1. Review specification
2. Identify affected modules
3. Check for architectural violations
4. Produce Architecture Decision Record

Output: `_docs/adrs/{task-id}.md`
```markdown
# ADR: [Task ID]

## Status
[PROPOSED | APPROVED | DEPRECATED]

## Context
[Why this change is needed]

## Decision
[What approach we're taking]

## Affected Modules
- [module 1] - [how affected]
- [module 2] - [how affected]

## Interface Changes
[Any API/interface modifications]

## Consequences
[Positive and negative outcomes]

## Risks and Mitigations
- Risk: [description]
  Mitigation: [approach]
```

Transition: Set status to READY_FOR_BUILD (if approved)

## Stage 3: Implementation (READY_FOR_BUILD) - Required

Purpose: Implement code and tests

Actions:
1. Read specification and ADR (if created)
2. Write tests first (TDD)
3. Implement to pass tests
4. Update documentation

Constraints:
- Follow ADR exactly (if exists)
- Do NOT modify interfaces beyond approved scope
- Do NOT refactor unrelated code

Transition: Set status to READY_FOR_REVIEW

## Stage 4: Code Review (READY_FOR_REVIEW) - Required

Purpose: Validate implementation quality

Actions:
1. Use code-reviewer subagent
2. Check against specification (if exists)
3. Check against ADR (if exists)
4. Identify issues

Outcomes:
- APPROVED → Transition to DONE
- ISSUES FOUND → Return to READY_FOR_BUILD with feedback

## Stage 5: Done (DONE)

Actions:
1. Commit changes
2. Update feature-list.json (passes: true)
3. Update activeContext.md
4. Clear pipeline state

## Pipeline Commands

`/pipeline-status` - Show current pipeline state
`/advance-stage` - Move to next stage (with validation)
`/skip-stage [stage]` - Skip optional stage with justification
`/rollback-stage` - Return to previous stage
```

### 4.4 Black Box Interface Guidelines

**Add to `.cursor/rules/base.mdc`:**

```markdown
## Black Box Interface Design

### Replaceability Test
Before modifying any module, ask:
"Could someone reimplement this module using ONLY its interface?"

If no: The abstraction has leaked. Fix the interface before modifying.

### One Obvious Job
Each module must have ONE obvious primary responsibility.
If you find yourself saying "this module handles X AND Y", split it.

### Interface-First Changes
When a task requires cross-module changes:
1. Define interface changes first (types, contracts)
2. Get interface approved in architecture stage (if pipeline enabled)
3. THEN implement against stable interfaces
4. NEVER modify interfaces during implementation

### Constant Velocity Principle
It's faster to write five clean lines today than one messy line today
and have to edit it (plus its callers) later.

### Forbidden Patterns
- Reaching into another module's internals
- Circular dependencies between modules
- Mixing concerns in a single function
- Changing interfaces during implementation stage
```

---

## Part 5: Context Management Enhancements

### 5.1 Progressive Disclosure Rule

**`.cursor/rules/context-management.mdc`:**
```markdown
---
description: Context window management and progressive disclosure
alwaysApply: true
---

# Context Management

## Progressive Disclosure

Do NOT preload entire files. Instead:
1. Maintain lightweight identifiers (file paths, function names)
2. Load data dynamically when needed
3. Discard details after use, keep summaries

### File Path Registry
Maintain mental registry of key files without reading content:
- Configuration: [paths]
- Core logic: [paths]
- Tests: [paths]
- Types/interfaces: [paths]

Read content ONLY when actively working on that file.

### Just-in-Time Retrieval
Before reading a file, ask:
- Do I need the ENTIRE file or just a function?
- Can I grep for the specific part I need?
- Has a subagent already summarized this?

If subagent summarized: Use summary, do NOT re-read.

## Compaction Protocol

### When to Compact
Monitor context usage. At 80% capacity:
1. Pause current operation (complete current step)
2. Trigger compaction
3. Resume with compressed context

### Compaction Priority (Remove First → Last)

1. **Tool Results** (remove first)
   - Remove raw tool outputs
   - Keep: summaries of findings

2. **Old Task Details**
   - Completed tasks: Keep only (task ID, status, commit hash)
   - Current task: Keep full details

3. **Code Snippets**
   - Remove code blocks from earlier tasks
   - Keep: file paths and brief descriptions

4. **Conditional Context** (remove last)
   - Remove: Old commit history, optional docs
   - Keep: activeContext.md, current task context

### Compaction Summary Format
After compacting, create inline summary:
```
## Context Compacted

Previous work (compressed):
- Task 1.1: Complete (commit abc123) - DynamoDB client
- Task 1.2: Complete (commit def456) - Retry logic
- Task 1.3: In progress - Current focus

Key decisions preserved:
- [Decision 1 with rationale]
- [Decision 2 with rationale]

Resuming from: [specific point]
```

## Subagent Context Isolation

### Why Subagents
Each subagent has its OWN context window:
- Explorer: Reads 40K+ tokens → Returns 1-2K summary
- Planner: Consumes 30K+ tokens → Returns 2-3K plan
- Implementer: Consumes 50K+ tokens → Returns 2-3K summary
- Code-Reviewer: Analyzes 30K+ tokens → Returns 2-3K report

Main agent receives ONLY the summary, preserving context.

### When to Use Subagents for Context
- Need to read >5 files: Use explorer subagent
- Need to analyze >3 changed files: Use code-reviewer subagent
- Implementation >50 lines: Use implementer subagent

### Summary Consumption
When subagent returns:
1. Read summary into main context
2. Do NOT request raw details
3. If more detail needed, spawn targeted follow-up subagent
```

### 5.2 Enhanced Memory Bank Updates

**Add to `.cursor/rules/memory-bank-management.mdc`:**

```markdown
## JSON Feature List Management

### Structure
`memory-bank/feature-list.json` is the source of truth for feature status.

### Update Rules

1. **Only `passes` field may change**
   ```json
   // Before
   {"id": "1.1", "description": "Login feature", "passes": false}
   
   // After (ONLY valid change)
   {"id": "1.1", "description": "Login feature", "passes": true}
   ```

2. **Never remove features**
   Features are immutable contracts. If a feature is no longer needed:
   - Add `"deprecated": true` field
   - Do NOT delete the entry

3. **Never edit descriptions or steps**
   If requirements change:
   - Create NEW feature with updated requirements
   - Mark old feature as deprecated
   - Reference new feature in notes

4. **Verification before marking passes: true**
   - All unit tests pass
   - Integration tests pass (if applicable)
   - End-to-end verification complete
   - Code review approved

### Feature List Categories

Use these standard categories:
- `functional` - User-facing features
- `integration` - System integrations
- `performance` - Performance requirements
- `security` - Security requirements

### Audit Trail
The `lastModified` field tracks when feature-list.json was updated.
Git history provides full audit trail of status changes.
```

---

## Part 6: Unified Commands

### 6.1 Command Updates for Subagent Integration

#### `/review` Command

**`.claude/commands/review.md`:**
```markdown
# Review Command

Review code changes using the code-reviewer subagent.

## Usage
```
/review [--staged | --all | files...]
```

## Process

1. Determine scope (staged changes, all changes, or specific files)
2. Delegate to code-reviewer subagent
3. Present review findings
4. Block commit if critical issues found

## Options

- `--staged` - Review only staged changes (default)
- `--all` - Review all uncommitted changes
- `files...` - Review specific files

## Output

Returns code-reviewer subagent report:
- Status: APPROVED or ISSUES FOUND
- Critical issues (must fix)
- Warnings (should fix)
- Suggestions (consider)
```

#### `/plan` Enhancement

**Update `.claude/commands/plan.md`:**

```markdown
## Subagent Integration

When planning a task:

1. **Use planner subagent** for codebase research
   - Understand existing architecture
   - Identify affected modules
   - Assess complexity

2. **Synthesize findings** into implementation plan
   - Do NOT re-explore what planner found
   - Build on planner's analysis

3. **Present plan** with clear attribution
   - "Based on planner analysis..."
   - Include affected files from planner output
```

#### `/implement` Command

**`.claude/commands/implement.md`:**

```markdown
# Implement Command

Execute implementation for a feature or task.

## Usage
```
/implement [feature-id] [--pipeline | --no-pipeline]
```

## Process

### For Simple Tasks (<50 lines, single file)
1. Use explorer subagent to understand context (if needed)
2. Implement directly (no implementer subagent)
3. Use code-reviewer subagent before commit

### For Complex Tasks (>50 lines OR multiple files)
1. Use explorer subagent to map affected files
2. Delegate to implementer subagent with clear context
3. Review implementer output
4. Use code-reviewer subagent before commit

### Pipeline Integration
- Default: Direct implementation (simple tasks) or auto-detect (complex)
- `--pipeline` flag: Enable full pipeline stages (spec → arch → build → review)
- `--no-pipeline` flag: Skip pipeline even for complex tasks (requires justification)

## Examples
```
/implement 1.1                    # Implement feature 1.1
/implement 1.1 --pipeline         # Force pipeline for feature 1.1
/implement 1.1 --no-pipeline      # Skip pipeline (simple change)
```
```

#### `/batch` Command

**`.claude/commands/batch.md`:**

```markdown
# Batch Command

Execute multiple features or an entire phase.

## Usage
```
/batch [feature-ids...] | Phase [N]
```

## Process

1. Parse feature list or phase number
2. For each feature in sequence:
   - Run `/implement [feature-id]`
   - Verify passes: true before continuing
   - Stop on failure
3. Report batch summary

## Examples
```
/batch 1.1 1.2 1.3               # Implement specific features
/batch Phase 1                    # Implement all Phase 1 features
```

## Behavior
- Features execute in order specified (or phase order)
- Each feature must pass before next begins
- Commits after each successful feature
- Stops batch on first failure
```

### 6.2 Command Quick Reference

| Command | Purpose | Subagent Used |
|---------|---------|---------------|
| `/begin-development` | Start/resume session | None |
| `/plan [feature-id]` | Create implementation plan | planner |
| `/implement [feature-id]` | Execute implementation | implementer (if complex) |
| `/batch [features]` | Multi-feature or phase execution | All (per feature) |
| `/review` | Review code changes | code-reviewer |
| `/commit-with-approval` | Commit with review | code-reviewer |
| `/commit-without-review` | Commit directly | None |
| `/pipeline-status` | Show pipeline state | None |
| `/advance-stage` | Move to next stage | Varies by stage |
| `/skip-stage [stage]` | Skip optional stage | None |
| `/pause` | Save session state | None |
| `/update-memory-bank` | Update memory bank files | None |
| `/summarize` | Summarize current state | None |

**Note:** To explore codebase, invoke explorer agent directly rather than using a command.

---

## Part 7: Implementation Roadmap

### Phase A: Foundation

**Priority: CRITICAL**

| Task | Priority | Output |
|------|----------|--------|
| A.1 Configure MCP subagent server | HIGH | `.cursor/mcp.json` |
| A.2 Configure CLI permissions | HIGH | `.cursor/cli.json` |
| A.3 Create explorer agent definition | HIGH | `.claude/agents/explorer.md` |
| A.4 Create planner agent definition | HIGH | `.claude/agents/planner.md` |
| A.5 Create implementer agent definition | HIGH | `.claude/agents/implementer.md` |
| A.6 Create code-reviewer agent definition | HIGH | `.claude/agents/code-reviewer.md` |
| A.7 Create subagent orchestration rule | HIGH | `.cursor/rules/subagent-orchestration.mdc` |
| A.8 Create context management rule | HIGH | `.cursor/rules/context-management.mdc` |
| A.9 Update base.mdc with orchestrator purity | HIGH | `.cursor/rules/base.mdc` |

**Validation:**
- Test explorer subagent invocation
- Test code-reviewer integration with commit workflow
- Measure context usage before/after subagent delegation

### Phase B: Session Management

**Priority: HIGH**

| Task | Priority | Output |
|------|----------|--------|
| B.1 Create feature-list.json schema | HIGH | Documentation + validation script |
| B.2 Update begin-development with first-session detection | HIGH | `.claude/commands/begin-development.md` |
| B.3 Create init.sh template (optional) | LOW | `scripts/init.sh.template` |
| B.4 Add feature-list immutability enforcement | HIGH | Validation in commit workflow |
| B.5 Merge projectBrief + productContext | MEDIUM | `memory-bank/projectContext.md` |

**Validation:**
- Run first-session flow on test project
- Verify continuing-session startup sequence
- Test feature-list update restrictions

### Phase C: Pipeline Architecture

**Priority: MEDIUM**

| Task | Priority | Output |
|------|----------|--------|
| C.1 Create pipeline-state.json schema | MEDIUM | Schema + validation |
| C.2 Create pipeline-stages rule | MEDIUM | `.cursor/rules/pipeline-stages.mdc` |
| C.3 Create spec template (optional) | LOW | `_docs/specs/template.md` |
| C.4 Create ADR template (optional) | LOW | `_docs/adrs/template.md` |
| C.5 Add pipeline commands | MEDIUM | `/pipeline-status`, `/advance-stage`, `/skip-stage` |
| C.6 Add black box interface guidelines | MEDIUM | Update to base.mdc |

**Validation:**
- Walk through pipeline with complex multi-file task
- Verify stage transitions
- Test skip-stage functionality

### Phase D: Unified Commands

**Priority: HIGH**

| Task | Priority | Output |
|------|----------|--------|
| D.1 Create /review command | HIGH | `.claude/commands/review.md` |
| D.2 Update /plan with subagent integration | HIGH | Command update |
| D.3 Update /implement (merged with /task) | HIGH | Command update |
| D.4 Create /batch command (merged with /one-shot) | MEDIUM | `.claude/commands/batch.md` |
| D.5 Create Claude Code compatibility guide | MEDIUM | Documentation |

**Validation:**
- Test all commands in Cursor
- Test all commands in Claude Code
- Verify consistent behavior

### Phase E: Refinement

**Priority: LOW**

| Task | Priority | Output |
|------|----------|--------|
| E.1 Add compaction prompts to autonomous mode | MEDIUM | Rule update |
| E.2 Create context health check script | MEDIUM | `scripts/check-context.sh` |
| E.3 Update README with V2 documentation | HIGH | README.md update |
| E.4 Performance testing and optimization | MEDIUM | Benchmarks and tuning |

---

## Part 8: Success Metrics

### Context Management

| Metric | V1 Baseline | V2 Target |
|--------|-------------|-----------|
| Context usage at task completion | 80-90% | <50% |
| Files re-read unnecessarily | 5-10 per task | <2 per task |
| Context compaction frequency | Manual only | Automatic at 80% |

### Multi-Part Edits

| Metric | V1 Baseline | V2 Target |
|--------|-------------|-----------|
| Cross-module refactoring incidents | Frequent | Rare (pipeline prevents) |
| Interface changes during implementation | Common | Blocked by stage gate |
| Rollback frequency due to scope creep | 1 in 5 tasks | <1 in 20 tasks |

### Session Continuity

| Metric | V1 Baseline | V2 Target |
|--------|-------------|-----------|
| Session startup time (to productive work) | 5-10 min | <2 min |
| Context loss between sessions | Significant | Minimal (JSON feature list) |
| Feature completion verification | Manual | Automated (e2e) |

### Subagent Effectiveness

| Metric | V2 Target |
|--------|-----------|
| Explorer subagent token expansion ratio | 40:1 (40K explored, 1K returned) |
| Code-reviewer subagent accuracy | 90%+ issues caught pre-commit |
| Implementer subagent first-pass success | 70%+ tasks complete without revision |

---

## Part 9: Risk Assessment

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| Native `.cursor/agents/` remains undocumented | Medium | Low | MCP approach is reliable fallback |
| MCP subagent spawning latency | Medium | Medium | Optimize for fewer, more targeted delegations |
| Cursor CLI hanging issues | Medium | Medium | Implement timeout wrappers |
| Feature-list immutability enforcement bypassed | Low | High | Add validation in commit hook |
| Pipeline overhead for simple tasks | Medium | Low | Pipeline is optional with explicit opt-in/opt-out |
| Claude Code command compatibility issues | Low | Medium | Test both platforms during development |
| Orchestrator purity violations | Medium | High | Add detection in pre-commit hook |

---

## Part 10: Finalized Decisions

| Decision | Choice | Rationale |
|----------|--------|-----------|
| Subagent Invocation | MCP server (`subagents` npm package) | Production-ready, works now |
| Agent Naming Convention | `-er` suffix (explorer, implementer, etc.) | Clearly indicates agent role |
| Pipeline Activation | Optional (>=5 files OR cross-module) | Reduces overhead for simple tasks |
| Feature List Format | JSON with immutable contracts | Structural enforcement, audit trail |
| Session Management | Single agent with first-session detection | Simpler than two-agent architecture |
| Memory Bank Structure | 5 files (merged projectContext, removed progress.md) | Reduced redundancy |
| Command Surface | 11 commands (merged task→implement, batch+one-shot→batch) | Simpler interface |
| Exploration | Direct agent invocation (no /explore command) | Reduces indirection |
| Claude Code Integration | Full compatibility | Identical commands in both tools |
| Rollout Scope | New projects only (V2 template) | Clean separation, no migration complexity |
| Spec/ADR Templates | Optional | Reduces overhead for well-defined tasks |
| Environment | Node 22+, Claude CLI available | Required for MCP subagents |

---

## Appendix A: File Templates

### Feature List Template

```json
{
  "version": "1.0",
  "project": "{{PROJECT_NAME}}",
  "created": "{{ISO_DATE}}",
  "lastModified": "{{ISO_DATE}}",
  "features": [
    {
      "id": "{{PHASE}}.{{NUMBER}}",
      "category": "{{functional|integration|performance|security}}",
      "description": "{{Human-readable description}}",
      "steps": [
        "{{Step 1}}",
        "{{Step 2}}"
      ],
      "passes": false,
      "blockedBy": [],
      "notes": ""
    }
  ]
}
```

### Project Context Template

```markdown
# Project Context

## Overview
{{Brief description of what this project is}}

## Problem Statement
{{What problem does this solve?}}

## Target Users
{{Who is this for?}}

## Core Requirements
{{Key requirements and constraints}}

## Technical Stack
{{Languages, frameworks, infrastructure}}

## Success Criteria
{{How do we know when it's done?}}
```

### Active Context Template

```markdown
# Active Context

## Current Session
- Started: {{timestamp}}
- Focus: {{current feature or task}}
- Branch: {{git branch}}

## Recent Changes
{{Summary of recent work}}

## Next Steps
{{What to do next}}

## Open Questions
{{Unresolved issues or decisions}}

## Session Notes
{{Any important context for future sessions}}
```

### Pipeline State Template

```json
{
  "version": "1.0",
  "currentStage": "IDLE",
  "currentTask": null,
  "pipelineEnabled": false,
  "history": []
}
```

### ADR Template (Optional)

```markdown
# ADR-{{NUMBER}}: {{TITLE}}

## Status
{{PROPOSED | APPROVED | DEPRECATED | SUPERSEDED}}

## Context
{{Why this decision is needed}}

## Decision
{{What we decided}}

## Consequences
{{Positive and negative outcomes}}

## Affected Modules
{{List of modules and how they're affected}}
```

### Specification Template (Optional)

```markdown
# Specification: {{TASK_ID}}

## Requirements
{{Clear, testable requirements}}

## Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2

## Out of Scope
{{What this does NOT include}}

## Questions Resolved
{{Answers to clarifying questions}}
```

---

## Appendix B: JSON Schemas

### Feature List Schema

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "properties": {
    "version": {"type": "string"},
    "project": {"type": "string"},
    "created": {"type": "string", "format": "date-time"},
    "lastModified": {"type": "string", "format": "date-time"},
    "features": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "id": {"type": "string"},
          "category": {"enum": ["functional", "integration", "performance", "security"]},
          "description": {"type": "string"},
          "steps": {"type": "array", "items": {"type": "string"}},
          "passes": {"type": "boolean"},
          "blockedBy": {"type": "array", "items": {"type": "string"}},
          "notes": {"type": "string"},
          "deprecated": {"type": "boolean"}
        },
        "required": ["id", "category", "description", "passes"]
      }
    }
  },
  "required": ["version", "project", "features"]
}
```

### Pipeline State Schema

```json
{
  "$schema": "http://json-schema.org/draft-07/schema#",
  "type": "object",
  "properties": {
    "version": {"type": "string"},
    "currentStage": {
      "enum": ["IDLE", "READY_FOR_SPEC", "READY_FOR_ARCH", "READY_FOR_BUILD", "READY_FOR_REVIEW", "DONE"]
    },
    "currentTask": {"type": ["string", "null"]},
    "pipelineEnabled": {"type": "boolean"},
    "history": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "stage": {"type": "string"},
          "timestamp": {"type": "string", "format": "date-time"},
          "taskId": {"type": "string"},
          "outcome": {"type": "string"}
        }
      }
    }
  },
  "required": ["version", "currentStage", "pipelineEnabled"]
}
```

---

## Appendix C: Environment Requirements

### Required

- Node.js 22.0.0+ (for MCP subagents package)
- Cursor IDE with MCP support
- Claude Code CLI (for subagent spawning)
- Git 2.30+

### Optional

- `subagents` npm package (for MCP integration)
- Context7 API key (for documentation lookup)

### Verification Script

```bash
#!/bin/bash
# scripts/verify-v2-requirements.sh

echo "Verifying V2 requirements..."

# Node version
NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
if [ "$NODE_VERSION" -lt 22 ]; then
  echo "ERROR: Node 22+ required (found: $(node -v))"
  exit 1
fi
echo "Node: OK ($(node -v))"

# Git version
GIT_VERSION=$(git --version | cut -d' ' -f3)
echo "Git: OK ($GIT_VERSION)"

# Claude CLI
if command -v claude &> /dev/null; then
  echo "Claude CLI: OK"
else
  echo "WARNING: Claude CLI not found (required for subagents)"
fi

# MCP config
if [ -f ".cursor/mcp.json" ]; then
  echo "MCP config: OK"
else
  echo "WARNING: .cursor/mcp.json not found"
fi

echo "Verification complete."
```
