#!/usr/bin/env bash
# daily-report.sh — Local wrapper for remote daily report collection and formatting.
# Claude's Bash access is scoped to this script only.
#
# Usage:
#   daily-report.sh collect [YYYY-MM-DD]
#   daily-report.sh format  [YYYY-MM-DD]
#   daily-report.sh validate [YYYY-MM-DD]
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REMOTE_HOST="lab-proxy"
REMOTE_SCRIPT="~/.claude/plugins/marketplaces/claude-toolbox/plugins/daily-report-remote/bin/collect-daily-data.sh"
VALIDATE_SCRIPT="${SCRIPT_DIR}/../../edge-ic/bin/validate-daily-report.sh"

# Also check the installed plugin cache location for the validator
if [ ! -f "$VALIDATE_SCRIPT" ]; then
    VALIDATE_SCRIPT="$HOME/.claude/plugins/marketplaces/edge-tooling/plugins/edge-ic/bin/validate-daily-report.sh"
fi

CMD="${1:-}"
DATE="${2:-$(date +%Y-%m-%d)}"

JSON_FILE="/tmp/remote-daily-data-${DATE}.json"
REPORT_FILE="/tmp/daily-report-${DATE}.txt"
SUGGESTIONS_FILE="/tmp/daily-report-${DATE}-suggestions.txt"

usage() {
    echo "Usage: $(basename "$0") {collect|format|validate} [YYYY-MM-DD]" >&2
    exit 1
}

cmd_collect() {
    echo "Collecting data from ${REMOTE_HOST} for ${DATE}..." >&2
    local output
    if ! output=$(ssh "$REMOTE_HOST" "bash ${REMOTE_SCRIPT} ${DATE}" 2>/dev/null); then
        echo "ERROR: SSH to ${REMOTE_HOST} failed" >&2
        exit 1
    fi

    if [ -z "$output" ]; then
        echo "ERROR: Collection script returned empty output" >&2
        exit 1
    fi

    echo "$output" > "$JSON_FILE"
    echo "Saved to ${JSON_FILE}" >&2
    echo "$output"
}

cmd_format() {
    if [ ! -f "$JSON_FILE" ]; then
        echo "ERROR: No collected data at ${JSON_FILE}. Run 'collect' first." >&2
        exit 1
    fi

    python3 "${SCRIPT_DIR}/format-report.py" "$JSON_FILE" "$REPORT_FILE" "$SUGGESTIONS_FILE"
    echo "Report written to ${REPORT_FILE}" >&2
    if [ -f "$SUGGESTIONS_FILE" ] && [ -s "$SUGGESTIONS_FILE" ]; then
        echo "Suggestions written to ${SUGGESTIONS_FILE}" >&2
    fi
    cat "$REPORT_FILE"
}

cmd_validate() {
    if [ ! -f "$REPORT_FILE" ]; then
        echo "ERROR: No report at ${REPORT_FILE}. Run 'format' first." >&2
        exit 1
    fi

    if [ -f "$VALIDATE_SCRIPT" ]; then
        bash "$VALIDATE_SCRIPT" "$REPORT_FILE"
    else
        echo "Validation script not found. Running inline checks..." >&2
        local errors=0

        head -1 "$REPORT_FILE" | grep -q "^Daily Report:" || { echo "FAIL: Missing 'Daily Report:' header"; errors=$((errors + 1)); }

        if grep -qP '```|^- \[' "$REPORT_FILE"; then
            echo "FAIL: Contains markdown formatting"
            errors=$((errors + 1))
        fi

        local valid_emojis=":done-circle-check:|:in-progress:|:jira-blocker:"
        while IFS= read -r line; do
            if echo "$line" | grep -qP '^:' && ! echo "$line" | grep -qP "^(${valid_emojis})"; then
                echo "FAIL: Invalid emoji in line: $line"
                errors=$((errors + 1))
            fi
        done < "$REPORT_FILE"

        if [ "$errors" -eq 0 ]; then
            echo "All inline checks passed."
        else
            echo "${errors} error(s) found." >&2
            exit 1
        fi
    fi
}

case "$CMD" in
    collect)  cmd_collect ;;
    format)   cmd_format ;;
    validate) cmd_validate ;;
    *)        usage ;;
esac
