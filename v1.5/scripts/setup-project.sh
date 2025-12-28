#!/bin/bash
# Initialize new project from template

set -e  # Exit on error

PROJECT_NAME=$1

if [ -z "$PROJECT_NAME" ]; then
  echo "Usage: ./setup-project.sh <project-name>"
  exit 1
fi

echo "🚀 Setting up new project: $PROJECT_NAME"
echo "========================================="

# Create project directory
mkdir -p "../$PROJECT_NAME"
cd "../$PROJECT_NAME"

echo "📋 Copying template files..."

# Copy template structure
cp -r ../ai-project-template/.cursor .
cp -r ../ai-project-template/memory-bank .
cp ../ai-project-template/.gitignore .
cp ../ai-project-template/.cursorignore .

# Copy _docs (excluding guides which aren't used yet)
mkdir -p _docs/_boilerplate
cp ../ai-project-template/_docs/README.md _docs/
cp -r ../ai-project-template/_docs/_boilerplate _docs/

# Copy tests
cp -r ../ai-project-template/tests .

# Copy scripts (excluding setup-project.sh which is template-only)
mkdir -p scripts
cp ../ai-project-template/scripts/pre-commit scripts/
cp ../ai-project-template/scripts/post-commit scripts/
cp ../ai-project-template/scripts/validate-project.sh scripts/
cp ../ai-project-template/scripts/audit-commits.sh scripts/
cp ../ai-project-template/scripts/verify-context.sh scripts/

echo "✏️  Customizing templates..."

# Rename template files
mv memory-bank/projectBrief.md.template memory-bank/projectBrief.md
mv memory-bank/productContext.md.template memory-bank/productContext.md
mv memory-bank/activeContext.md.template memory-bank/activeContext.md
mv memory-bank/systemPatterns.md.template memory-bank/systemPatterns.md
mv memory-bank/techContext.md.template memory-bank/techContext.md
mv memory-bank/progress.md.template memory-bank/progress.md

# Replace PROJECT_NAME placeholder
find memory-bank _docs -type f -name "*.md" -exec sed -i '' "s/\[PROJECT NAME\]/$PROJECT_NAME/g" {} +

echo "📝 Creating initial git repository..."
git init

echo "🔧 Installing git hooks..."
cp scripts/pre-commit .git/hooks/pre-commit
cp scripts/post-commit .git/hooks/post-commit
chmod +x .git/hooks/pre-commit
chmod +x .git/hooks/post-commit

# Remove hook source files from scripts/ (they're now in .git/hooks/)
rm scripts/pre-commit scripts/post-commit

git add .
git commit -n -m "chore: initialize project from ai-template [skip-review]"

echo ""
echo "✅ Project setup complete!"
echo ""
echo "Git hooks installed - commits will trigger autonomous code review"
echo ""
echo "========================================="
echo "NEXT STEPS: Follow Part 2 in the main README"
echo "========================================="
echo ""
echo "1. Navigate to your project:"
echo "   cd ../$PROJECT_NAME"
echo ""
echo "2. Place your PRD at $PROJECT_NAME/_docs/prd.md:"
echo ""
echo "3. Optional - Validate your project structure:"
echo "   ./scripts/validate-project.sh"
echo ""
echo "4. Initialize project with Claude Code:"
echo "   Open Cursor or Claude Code and start a chat with:"
echo "   @_docs/_boilerplate/project-prompt-template.md"
echo ""
echo "5. If initialized with Claude, ask Claude to update the memory bank based on @$PROJECT_NAME/.cursor/commands/update-memory-bank.md"
echo "   If initialized with Cursor, use /update-memory-bank command"
echo ""
echo "6. Begin development:"
echo "   Use /begin-development command in Cursor"
echo ""
echo "========================================="
echo "NOTE"
echo "========================================="
echo "The /begin-development command automatically loads Memory Bank"
echo "context at the start of each chat. Use this command to ensure"
echo "Cursor agents have full project context before starting work."
echo ""
