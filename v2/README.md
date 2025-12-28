# V2 Scaffold

AI-assisted development scaffold with emphasis on context management through subagent orchestration.

## Features

- **Subagent System**: Explorer, Planner, Implementer, Code-Reviewer agents for context isolation
- **Slash Commands**: Unified interface executable by Cursor or Claude Code
- **Memory Bank**: Persistent context across sessions
- **Pipeline Architecture**: Optional staged workflow for complex tasks
- **Pre-commit Review**: Claude CLI code review gate

## Requirements

- Node.js 22+ (for Cursor subagent MCP)
- Git
- jq (for JSON validation)
- Claude CLI (`npm install -g @anthropic-ai/claude-code`)

## Quick Start

1. Copy `v2/` contents to your project root
2. Run `./scripts/install-hooks.sh` to install git hooks
3. Run `./scripts/verify-requirements.sh` to verify setup
4. Run `/begin-development` to start

## Directory Structure

```
.cursor/
├── rules/                    # Cursor rule files
│   ├── base.mdc
│   ├── subagent-orchestration.mdc
│   ├── context-management.mdc
│   ├── memory-bank-management.mdc
│   ├── development-workflow.mdc
│   ├── testing-standards.mdc
│   ├── commit-workflow.mdc
│   └── pipeline-stages.mdc
├── mcp.json                  # MCP server configuration
└── cli.json                  # CLI permissions

.claude/
├── commands/                 # Slash commands
│   ├── map.md
│   ├── plan.md
│   ├── implement.md
│   ├── review.md
│   ├── begin-development.md
│   ├── batch.md
│   ├── commit-with-approval.md
│   ├── commit-without-review.md
│   ├── pause.md
│   ├── update-memory-bank.md
│   ├── summarize.md
│   ├── pipeline-status.md
│   ├── advance-stage.md
│   ├── skip-stage.md
│   └── rollback-stage.md
└── agents/                   # Subagent definitions
    ├── explorer.md
    ├── planner.md
    ├── implementer.md
    └── code-reviewer.md

memory-bank/                  # Persistent context templates
├── projectContext.md.template
├── activeContext.md.template
├── systemPatterns.md.template
├── techContext.md.template
└── feature-list.json.template

_docs/
├── exploration/              # /map outputs
├── specs/                    # /plan outputs
│   └── template.md
├── adrs/                     # Architecture Decision Records
│   └── template.md
└── pipeline-state.json

scripts/
├── hooks/
│   └── pre-commit
├── install-hooks.sh
└── verify-requirements.sh

CLAUDE.md                     # Claude Code configuration
```

## Commands

| Command | Purpose | Subagent |
|---------|---------|----------|
| `/begin-development` | Start/resume session | - |
| `/map <target>` | Explore codebase | explorer |
| `/plan <feature>` | Create implementation plan | planner |
| `/implement <feature>` | Implement with TDD | implementer |
| `/review` | Early code review | code-reviewer |
| `/batch <features>` | Multi-feature execution | all |
| `/commit-with-approval` | Commit with review gate | - |
| `/commit-without-review` | Commit bypassing review | - |
| `/pause` | Save session state | - |
| `/update-memory-bank` | Sync memory bank | - |
| `/summarize` | Context summary | - |

## Pipeline Commands (Optional)

| Command | Purpose |
|---------|---------|
| `/pipeline-status` | Show pipeline state |
| `/advance-stage` | Move to next stage |
| `/skip-stage` | Skip optional stage |
| `/rollback-stage` | Return to previous stage |

## Compatibility

| Feature | Cursor | Claude Code |
|---------|--------|-------------|
| `.claude/commands/` | Supported | Supported |
| `.claude/agents/` | Via MCP | Native |
| `.cursor/rules/` | Native | Not read |
| `CLAUDE.md` | Not read | Native |
