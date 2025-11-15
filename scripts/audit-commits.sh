#!/bin/bash

# Audit script to review commits that bypassed pre-commit hook

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

BYPASS_LOG="_logs/commit-bypasses.log"
ALL_COMMITS_LOG="_logs/all-commits.log"

echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}           COMMIT AUDIT - Pre-commit Hook Bypass Detection${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo ""

# ============================================================================
# CHECK FOR BYPASSED COMMITS
# ============================================================================

if [ -f "$BYPASS_LOG" ]; then
    # Count total bypasses
    BYPASS_COUNT=$(grep -c "PRE-COMMIT HOOK BYPASSED" "$BYPASS_LOG")

    # Count authorized bypasses (with [skip-review] marker)
    AUTHORIZED_COUNT=$(grep -c "skip-review" "$BYPASS_LOG" 2>/dev/null)
    if [ $? -ne 0 ]; then
        AUTHORIZED_COUNT=0
    fi

    # Calculate violations (bypasses without authorization)
    VIOLATION_COUNT=$((BYPASS_COUNT - AUTHORIZED_COUNT))

    if [ $VIOLATION_COUNT -gt 0 ]; then
        echo -e "${RED}⚠️  VIOLATIONS DETECTED: Commits bypassed without authorization${NC}"
        echo ""
        echo -e "${RED}Unauthorized bypasses: $VIOLATION_COUNT${NC}"
        echo ""

        # Show only violations (no [skip-review] marker)
        echo -e "${YELLOW}Violation details:${NC}"
        echo ""

        # Parse log and show violations only
        awk '
        BEGIN { in_section=0; buffer=""; has_marker=0 }
        /═════════════════════════════════════════════════════════════/ {
            if (in_section && buffer != "" && !has_marker) {
                print buffer
            }
            in_section=1
            buffer=""
            has_marker=0
            next
        }
        in_section {
            buffer = buffer $0 "\n"
            if ($0 ~ /skip-review/) {
                has_marker=1
            }
        }
        END {
            if (in_section && buffer != "" && !has_marker) {
                print buffer
            }
        }
        ' "$BYPASS_LOG"
    else
        echo -e "${GREEN}✓ No violations found.${NC}"
    fi

    if [ $AUTHORIZED_COUNT -gt 0 ]; then
        echo ""
        echo -e "${BLUE}ℹ️  Authorized bypasses: $AUTHORIZED_COUNT${NC}"
        echo -e "${BLUE}   (commits with [skip-review] marker)${NC}"
    fi

    echo ""
    echo -e "${CYAN}Total bypassed commits: $BYPASS_COUNT${NC}"
    echo -e "${CYAN}  - Authorized: $AUTHORIZED_COUNT${NC}"
    echo -e "${CYAN}  - Violations: $VIOLATION_COUNT${NC}"
else
    echo -e "${GREEN}✓ No bypassed commits found.${NC}"
    BYPASS_COUNT=0
    AUTHORIZED_COUNT=0
    VIOLATION_COUNT=0
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
    BYPASSED=$(grep -c "BYPASSED PRE-COMMIT" "$ALL_COMMITS_LOG" 2>/dev/null)
    if [ $? -ne 0 ]; then
        BYPASSED=0
    fi
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

if [ $VIOLATION_COUNT -gt 0 ]; then
    echo -e "${YELLOW}─────────────────────────────────────────────────────────────${NC}"
    echo -e "${YELLOW}           Recommendations${NC}"
    echo -e "${YELLOW}─────────────────────────────────────────────────────────────${NC}"
    echo ""
    echo -e "${RED}VIOLATIONS DETECTED:${NC} $VIOLATION_COUNT commit(s) bypassed without authorization."
    echo ""
    echo "These commits were created with --no-verify or -n flag but lack the"
    echo "[skip-review] marker indicating authorized bypass."
    echo ""
    echo "For manual commits: Use /commit-without-review command for proper authorization."
    echo "For AI agent commits: This violates the commit workflow rules."
    echo ""
    echo "To review violations:"
    echo -e "  ${GREEN}cat $BYPASS_LOG | grep -B 20 -A 5 'Commit Message:' | grep -v '\[skip-review\]'${NC}"
    echo ""
    echo "To see all commits:"
    echo -e "  ${GREEN}cat $ALL_COMMITS_LOG${NC}"
    echo ""
elif [ $AUTHORIZED_COUNT -gt 0 ]; then
    echo -e "${BLUE}─────────────────────────────────────────────────────────────${NC}"
    echo -e "${BLUE}           Summary${NC}"
    echo -e "${BLUE}─────────────────────────────────────────────────────────────${NC}"
    echo ""
    echo -e "${GREEN}✓ All bypasses were authorized${NC}"
    echo ""
    echo "$AUTHORIZED_COUNT commit(s) bypassed code review with proper authorization"
    echo "(using [skip-review] marker via /commit-without-review command)."
    echo ""
fi

echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
