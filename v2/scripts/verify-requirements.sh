#!/bin/bash
# Verify V2 scaffold requirements

echo "Verifying V2 requirements..."
ERRORS=0

# Node version (22+ required for Cursor subagent MCP)
if command -v node &> /dev/null; then
    NODE_VERSION=$(node -v | cut -d'v' -f2 | cut -d'.' -f1)
    if [ "$NODE_VERSION" -ge 22 ]; then
        echo "✓ Node.js: $(node -v)"
    else
        echo "✗ Node.js 22+ required (found: $(node -v))"
        echo "  Note: Node 22+ is required for Cursor subagent MCP"
        ERRORS=$((ERRORS + 1))
    fi
else
    echo "✗ Node.js not found"
    ERRORS=$((ERRORS + 1))
fi

# Git version
if command -v git &> /dev/null; then
    echo "✓ Git: $(git --version | cut -d' ' -f3)"
else
    echo "✗ Git not found"
    ERRORS=$((ERRORS + 1))
fi

# jq (for JSON validation in hooks)
if command -v jq &> /dev/null; then
    echo "✓ jq: $(jq --version)"
else
    echo "✗ jq not found (required for pre-commit validation)"
    ERRORS=$((ERRORS + 1))
fi

# Claude CLI (required for pre-commit code review)
if command -v claude &> /dev/null; then
    echo "✓ Claude CLI: available"
else
    echo "✗ Claude CLI not found (required for pre-commit code review)"
    echo "  Install: npm install -g @anthropic-ai/claude-code"
    ERRORS=$((ERRORS + 1))
fi

# Directory structure
echo ""
echo "Checking directory structure..."

REQUIRED_DIRS=(
    ".cursor/rules"
    ".claude/commands"
    ".claude/agents"
    "memory-bank"
    "_docs"
    "_docs/exploration"
    "_docs/specs"
    "_docs/adrs"
)

for dir in "${REQUIRED_DIRS[@]}"; do
    if [ -d "$dir" ]; then
        echo "✓ $dir"
    else
        echo "✗ $dir (missing)"
        ERRORS=$((ERRORS + 1))
    fi
done

# Required files
echo ""
echo "Checking required files..."

REQUIRED_FILES=(
    ".cursor/rules/base.mdc"
    ".cursor/rules/subagent-orchestration.mdc"
    ".cursor/rules/context-management.mdc"
    ".cursor/rules/memory-bank-management.mdc"
    ".claude/commands/begin-development.md"
    ".claude/commands/map.md"
    ".claude/commands/plan.md"
    ".claude/commands/implement.md"
    ".claude/commands/review.md"
    ".claude/agents/explorer.md"
    ".claude/agents/planner.md"
    ".claude/agents/implementer.md"
    ".claude/agents/code-reviewer.md"
    "CLAUDE.md"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "$file" ]; then
        echo "✓ $file"
    else
        echo "✗ $file (missing)"
        ERRORS=$((ERRORS + 1))
    fi
done

# Check git hooks
echo ""
echo "Checking git hooks..."

if [ -f ".git/hooks/pre-commit" ] && [ -x ".git/hooks/pre-commit" ]; then
    echo "✓ pre-commit hook installed"
else
    echo "✗ pre-commit hook not installed"
    echo "  Run: ./scripts/install-hooks.sh"
    ERRORS=$((ERRORS + 1))
fi

echo ""
if [ $ERRORS -eq 0 ]; then
    echo "All requirements satisfied!"
    exit 0
else
    echo "Found $ERRORS issues. Please resolve before proceeding."
    exit 1
fi
