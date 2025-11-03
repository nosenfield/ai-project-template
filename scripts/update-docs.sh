#!/bin/bash
# Prompt for documentation updates after development

echo "📚 Documentation Update Check"
echo "============================="
echo ""
echo "📖 See .cursor/rules/memory-bank-management.mdc for detailed guidance"
echo ""
echo "Quick checklist:"
echo ""
echo "1. memory-bank/progress.md"
echo "   ↳ Mark completed tasks"
echo "   ↳ Update known issues"
echo "   ↳ See memory-bank-management.mdc for what to include"
echo ""
echo "2. memory-bank/activeContext.md"
echo "   ↳ Update current work focus"
echo "   ↳ Document recent decisions"
echo "   ↳ See memory-bank-management.mdc for update triggers"
echo ""
echo "3. Other memory-bank files (if needed)"
echo "   ↳ systemPatterns.md (if architecture changed)"
echo "   ↳ techContext.md (if tech stack changed)"
echo ""
echo "4. _docs/architecture.md (if changed)"
echo "   ↳ New patterns"
echo "   ↳ Updated diagrams"
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
