# {{PROJECT_NAME}}

## Commands
Run `/begin-development` to start or resume a session.

See `.claude/commands/` for all available commands:
- `/map <target>` - Explore codebase
- `/plan <feature>` - Create implementation plan
- `/implement <feature>` - Implement with TDD
- `/review` - Early feedback on changes
- `/commit-with-approval` - Commit with review gate
- `/commit-without-review` - Commit bypassing review
- `/pause` - Save session state
- `/batch <features>` - Multi-feature execution

## Build and Test
```bash
# Install dependencies
{{INSTALL_COMMAND}}

# Run development server
{{DEV_COMMAND}}

# Run tests
{{TEST_COMMAND}}

# Run linter
{{LINT_COMMAND}}
```

## Core Principles

### Orchestrator Purity
Delegate to subagents when:
- Exploration requires >5 file reads
- Implementation exceeds 50 lines
- Changes span multiple files

Execute directly when:
- Simple queries answerable from context
- Small edits (<20 lines, single file)

### Context Management
- Maintain file path registry without reading contents
- Load data just-in-time when actively working
- Use subagent summaries; do not re-read explored files
- Check `_docs/exploration/` for existing explorations
- Check `_docs/specs/` for existing plans

### Memory Bank
- Read `memory-bank/` files at session start
- Update `activeContext.md` when pausing or completing features
- Only modify `passes` field in `feature-list.json`
- Never remove or edit feature definitions

### Quality Standards
- Write tests before implementation
- Keep functions under 50 lines
- Verify features end-to-end before marking complete
- Commit with descriptive conventional commit messages

## Project Structure
```
.claude/commands/    # Slash commands
.claude/agents/      # Subagent definitions
memory-bank/         # Persistent context
_docs/               # Specifications, explorations, reviews
```

## Key Files
- `memory-bank/projectContext.md` - Project overview
- `memory-bank/activeContext.md` - Current session state
- `memory-bank/feature-list.json` - Feature tracking
- `_docs/best-practices.md` - Coding standards
