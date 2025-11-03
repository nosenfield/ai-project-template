#!/bin/bash
# Prompt for documentation updates after development

echo "📚 Documentation Update Check"
echo "============================="
echo ""
echo "Review and update these files:"
echo ""
echo "1. memory-bank/progress.md"
echo "   ↳ Mark completed tasks"
echo "   ↳ Update known issues"
echo ""
echo "2. memory-bank/activeContext.md"
echo "   ↳ Current work focus"
echo "   ↳ Recent decisions"
echo ""
echo "3. _docs/architecture.md (if changed)"
echo "   ↳ New patterns"
echo "   ↳ Updated diagrams"
echo ""
echo "4. .cursor/rules/ (if new patterns)"
echo "   ↳ Document discoveries"
echo ""

# Check git status
CHANGED_FILES=$(git diff --name-only HEAD)

if [ -n "$CHANGED_FILES" ]; then
  echo "📄 Files changed in this session:"
  echo "$CHANGED_FILES"
  echo ""
fi

# Open key files in editor
if command -v cursor &> /dev/null; then
  cursor memory-bank/progress.md memory-bank/activeContext.md
  echo "✅ Opened files in Cursor"
elif command -v code &> /dev/null; then
  code memory-bank/progress.md memory-bank/activeContext.md
  echo "✅ Opened files in VS Code"
else
  echo "⚠️  No editor found. Please manually update files."
fi

echo ""
echo "💡 Tip: Run this after completing features or at end of session"
