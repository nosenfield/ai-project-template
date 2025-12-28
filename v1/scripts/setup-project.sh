#!/bin/bash
# Initialize new project from V1 template

set -e  # Exit on error

PROJECT_NAME=$1

if [ -z "$PROJECT_NAME" ]; then
  echo "Usage: ./setup-project.sh <project-name>"
  exit 1
fi

# Get the directory where this script lives (v1/scripts/)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TEMPLATE_DIR="$(dirname "$SCRIPT_DIR")"  # v1/

echo "Setting up new project: $PROJECT_NAME"
echo "========================================="
echo "Source template: $TEMPLATE_DIR"

# Create project directory (sibling to ai-project-template)
PROJECT_DIR="$(dirname "$(dirname "$TEMPLATE_DIR")")/$PROJECT_NAME"
mkdir -p "$PROJECT_DIR"
cd "$PROJECT_DIR"

echo ""
echo "Copying template files..."

# Copy .cursor structure (commands, rules, mcp.json)
cp -r "$TEMPLATE_DIR/.cursor" .

# Copy memory-bank templates
cp -r "$TEMPLATE_DIR/memory-bank" .

# Copy .gitignore and .cursorignore
cp "$TEMPLATE_DIR/.gitignore" .
cp "$TEMPLATE_DIR/.cursorignore" .

# Copy _docs structure
mkdir -p _docs/_boilerplate
mkdir -p _docs/_backups
mkdir -p _docs/best-practices
mkdir -p _docs/task-list
mkdir -p _docs/guides
cp "$TEMPLATE_DIR/_docs/README.md" _docs/
cp -r "$TEMPLATE_DIR/_docs/_boilerplate"/* _docs/_boilerplate/
cp "$TEMPLATE_DIR/_docs/_backups/.gitkeep" _docs/_backups/
cp "$TEMPLATE_DIR/_docs/best-practices/.gitkeep" _docs/best-practices/
cp "$TEMPLATE_DIR/_docs/task-list/.gitkeep" _docs/task-list/
cp -r "$TEMPLATE_DIR/_docs/guides"/* _docs/guides/

# Copy tests
cp -r "$TEMPLATE_DIR/tests" .

# Copy scripts (excluding setup-project.sh which is template-only)
mkdir -p scripts
cp "$TEMPLATE_DIR/scripts/pre-commit" scripts/
cp "$TEMPLATE_DIR/scripts/post-commit" scripts/
cp "$TEMPLATE_DIR/scripts/validate-project.sh" scripts/
cp "$TEMPLATE_DIR/scripts/audit-commits.sh" scripts/
cp "$TEMPLATE_DIR/scripts/verify-context.sh" scripts/

# Create _logs directory
mkdir -p _logs
cp "$TEMPLATE_DIR/_logs/.gitkeep" _logs/

echo ""
echo "Customizing templates..."

# Rename template files
mv memory-bank/projectbrief.md.template memory-bank/projectBrief.md
mv memory-bank/productContext.md.template memory-bank/productContext.md
mv memory-bank/activeContext.md.template memory-bank/activeContext.md
mv memory-bank/systemPatterns.md.template memory-bank/systemPatterns.md
mv memory-bank/techContext.md.template memory-bank/techContext.md
mv memory-bank/progress.md.template memory-bank/progress.md

# Replace PROJECT_NAME placeholder
find memory-bank _docs -type f -name "*.md" -exec sed -i '' "s/\[PROJECT NAME\]/$PROJECT_NAME/g" {} +

echo ""
echo "Creating initial git repository..."
git init

echo ""
echo "Installing git hooks..."
cp scripts/pre-commit .git/hooks/pre-commit
cp scripts/post-commit .git/hooks/post-commit
chmod +x .git/hooks/pre-commit
chmod +x .git/hooks/post-commit

# Remove hook source files from scripts/ (they're now in .git/hooks/)
rm scripts/pre-commit scripts/post-commit

git add .
git commit -n -m "chore: initialize project from ai-template v1 [skip-review]"

echo ""
echo "Project setup complete!"
echo ""
echo "Git hooks installed - commits will trigger autonomous code review"
echo ""
echo "========================================="
echo "NEXT STEPS"
echo "========================================="
echo ""
echo "1. Navigate to your project:"
echo "   cd $PROJECT_DIR"
echo ""
echo "2. Create your PRD at _docs/prd.md"
echo ""
echo "3. Optional - Validate your project structure:"
echo "   ./scripts/validate-project.sh"
echo ""
echo "4. Initialize project with Claude:"
echo "   Open Cursor or Claude Code and use prompt:"
echo "   @_docs/_boilerplate/project-prompt-template.md"
echo ""
echo "5. Update the memory bank:"
echo "   Cursor: /update-memory-bank"
echo "   Claude Code: @.cursor/commands/update-memory-bank.md"
echo ""
echo "6. Begin development:"
echo "   Cursor: /begin-development"
echo "   Claude Code: @.cursor/commands/begin-development.md"
echo ""
