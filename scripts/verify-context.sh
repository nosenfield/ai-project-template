#!/bin/bash
# Verify context health and completeness

echo "🔍 Context Health Check"
echo "======================"
echo ""

# Required files
REQUIRED_FILES=(
  "memory-bank/projectbrief.md"
  "memory-bank/activeContext.md"
  "memory-bank/progress.md"
  "_docs/architecture.md"
  ".cursor/rules/base.mdc"
)

MISSING=0

echo "📁 Checking required files..."
for file in "${REQUIRED_FILES[@]}"; do
  if [ ! -f "$file" ]; then
    echo "❌ Missing: $file"
    MISSING=1
  else
    # Check if file is empty
    if [ ! -s "$file" ]; then
      echo "⚠️  Empty: $file"
      MISSING=1
    else
      echo "✅ Found: $file"
    fi
  fi
done

echo ""

# Check documentation freshness
echo "📅 Documentation freshness..."
PROGRESS_AGE=$(git log -1 --format="%ar" memory-bank/progress.md 2>/dev/null || echo "never")
ACTIVE_AGE=$(git log -1 --format="%ar" memory-bank/activeContext.md 2>/dev/null || echo "never")

echo "progress.md last updated: $PROGRESS_AGE"
echo "activeContext.md last updated: $ACTIVE_AGE"

echo ""

# Check for undocumented changes
UNCOMMITTED=$(git diff --name-only | wc -l)
if [ "$UNCOMMITTED" -gt 0 ]; then
  echo "⚠️  You have $UNCOMMITTED uncommitted file(s)"
  echo "   Consider updating documentation before committing"
fi

echo ""

# Overall health
if [ $MISSING -eq 0 ]; then
  echo "✅ Context health: GOOD"
  echo ""
  echo "💡 Recommendations:"
  echo "   • Update Memory Bank if you've completed tasks recently"
  echo "   • See .cursor/rules/memory-bank-management.mdc for procedures"
  echo "   • Run scripts/update-docs.sh to review files"
  exit 0
else
  echo "⚠️  Context health: NEEDS ATTENTION"
  echo ""
  echo "🔧 Action required:"
  echo "   • Create missing files"
  echo "   • Fill in empty templates"
  echo "   • Update stale documentation"
  echo ""
  echo "📖 See .cursor/rules/memory-bank-management.mdc for:"
  echo "   • New project initialization procedure"
  echo "   • File-by-file content guidance"
  exit 1
fi
