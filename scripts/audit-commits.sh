#!/bin/bash

# Audit script to review commits that bypassed pre-commit hook

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

BYPASS_LOG="_logs/commit-violations.log"
ALL_COMMITS_LOG="_logs/all-commits.log"

echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}           COMMIT AUDIT - Pre-commit Hook Bypass Detection${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo ""

# ============================================================================
# CHECK FOR BYPASSED COMMITS
# ============================================================================

if [ -f "$BYPASS_LOG" ]; then
    echo -e "${YELLOW}📋 Commits that bypassed pre-commit hook:${NC}"
    echo ""
    cat "$BYPASS_LOG"

    BYPASS_COUNT=$(grep -c "PRE-COMMIT HOOK BYPASSED" "$BYPASS_LOG")
    echo ""
    echo -e "${RED}Total bypassed commits: $BYPASS_COUNT${NC}"
else
    echo -e "${GREEN}✓ No bypassed commits found.${NC}"
    BYPASS_COUNT=0
fi

echo ""

# ============================================================================
# SHOW COMMIT SUMMARY
# ============================================================================

if [ -f "$ALL_COMMITS_LOG" ]; then
    echo -e "${CYAN}─────────────────────────────────────────────────────────────${NC}"
    echo -e "${CYAN}           All Commits Summary${NC}"
    echo -e "${CYAN}─────────────────────────────────────────────────────────────${NC}"
    echo ""

    TOTAL_COMMITS=$(wc -l < "$ALL_COMMITS_LOG" | tr -d ' ')
    BYPASSED=$(grep -c "BYPASSED PRE-COMMIT" "$ALL_COMMITS_LOG" 2>/dev/null || echo 0)
    NORMAL=$((TOTAL_COMMITS - BYPASSED))

    echo -e "${BLUE}Total commits logged:${NC}       $TOTAL_COMMITS"
    echo -e "${GREEN}Commits with pre-commit:${NC}    $NORMAL"
    echo -e "${RED}Commits bypassed:${NC}           $BYPASSED"

    if [ $TOTAL_COMMITS -gt 0 ]; then
        BYPASS_PERCENTAGE=$(awk "BEGIN {printf \"%.1f\", ($BYPASSED / $TOTAL_COMMITS) * 100}")
        echo -e "${YELLOW}Bypass rate:${NC}                $BYPASS_PERCENTAGE%"
    fi

    echo ""
    echo -e "${CYAN}Recent commits (last 10):${NC}"
    tail -n 10 "$ALL_COMMITS_LOG" | while IFS= read -r line; do
        if echo "$line" | grep -q "BYPASSED PRE-COMMIT"; then
            echo -e "${RED}$line${NC}"
        else
            echo -e "${GREEN}$line${NC}"
        fi
    done
else
    echo -e "${YELLOW}No commit log found at: $ALL_COMMITS_LOG${NC}"
fi

echo ""

# ============================================================================
# SHOW DETAILED BREAKDOWN BY AUTHOR
# ============================================================================

if [ -f "$BYPASS_LOG" ] && [ $BYPASS_COUNT -gt 0 ]; then
    echo -e "${CYAN}─────────────────────────────────────────────────────────────${NC}"
    echo -e "${CYAN}           Bypassed Commits by Author${NC}"
    echo -e "${CYAN}─────────────────────────────────────────────────────────────${NC}"
    echo ""

    grep "Author:" "$BYPASS_LOG" | sort | uniq -c | sort -rn | while read count author; do
        echo -e "${YELLOW}$count${NC} bypassed commit(s) by ${BLUE}${author#Author: }${NC}"
    done

    echo ""
fi

# ============================================================================
# RECOMMENDATIONS
# ============================================================================

if [ $BYPASS_COUNT -gt 0 ]; then
    echo -e "${YELLOW}─────────────────────────────────────────────────────────────${NC}"
    echo -e "${YELLOW}           Recommendations${NC}"
    echo -e "${YELLOW}─────────────────────────────────────────────────────────────${NC}"
    echo ""
    echo "Bypassed commits detected. These commits were created with --no-verify or -n flag."
    echo ""
    echo "For manual commits: This is allowed but logged for audit purposes."
    echo "For AI agent commits: This violates the commit workflow rules."
    echo ""
    echo "To review specific violations:"
    echo -e "  ${GREEN}cat $BYPASS_LOG${NC}"
    echo ""
    echo "To see all commits:"
    echo -e "  ${GREEN}cat $ALL_COMMITS_LOG${NC}"
    echo ""
fi

echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
