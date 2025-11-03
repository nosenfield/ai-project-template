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
cp -r ../ai-project-template/_docs .
cp -r ../ai-project-template/tests .
cp -r ../ai-project-template/scripts .
cp ../ai-project-template/.gitignore .

echo "✏️  Customizing templates..."

# Rename template files
mv memory-bank/projectbrief.md.template memory-bank/projectbrief.md
mv memory-bank/productContext.md.template memory-bank/productContext.md
mv memory-bank/activeContext.md.template memory-bank/activeContext.md
mv memory-bank/systemPatterns.md.template memory-bank/systemPatterns.md
mv memory-bank/techContext.md.template memory-bank/techContext.md
mv memory-bank/progress.md.template memory-bank/progress.md

# Replace PROJECT_NAME placeholder
find memory-bank _docs -type f -name "*.md" -exec sed -i '' "s/\[PROJECT NAME\]/$PROJECT_NAME/g" {} +

echo "📝 Creating initial git repository..."
git init
git add .
git commit -m "chore: initialize project from ai-template"

echo ""
echo "✅ Project setup complete!"
echo ""
echo "Next steps:"
echo "1. cd ../$PROJECT_NAME"
echo "2. Fill in memory-bank/projectbrief.md"
echo "3. Create _docs/architecture.md"
echo "4. Define _docs/task-list.md"
echo "5. Add stack-specific best practices to _docs/best-practices/"
echo "6. Start development!"
echo ""
echo "📚 Remember: AI should read memory-bank/activeContext.md and progress.md every session"
