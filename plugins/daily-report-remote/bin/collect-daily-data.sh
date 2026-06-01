#!/usr/bin/env bash
# collect-daily-data.sh — Gather daily report data from this host and emit JSON.
#
# Usage: collect-daily-data.sh [YYYY-MM-DD]
#   Defaults to today's date if not specified.
#
# Output: JSON object with todo, git_logs, and sessions fields to stdout.
#         Diagnostic messages go to stderr.

set -euo pipefail

DATE="${1:-$(date +%Y-%m-%d)}"
YEAR="${DATE:0:4}"
MONTH="${DATE:5:2}"
HOST="$(hostname -s)"

TODO_FILE="$HOME/.daily/${YEAR}/${MONTH}/${DATE}.md"

# --- Repo discovery ---
REPO_ROOTS=(
    "$HOME/microshift"
    "$HOME/Workspace/github.com/openshift"
    "$HOME/Workspace/github.com/copejon"
    "$HOME/Workspace/claude"
)

discover_repos() {
    for root in "${REPO_ROOTS[@]}"; do
        if [ -d "$root/.git" ] || [ -f "$root/.git" ]; then
            echo "$root"
        elif [ -d "$root" ]; then
            for child in "$root"/*/; do
                [ -d "$child/.git" ] || [ -f "$child/.git" ] && echo "${child%/}"
            done
        fi
    done
}

# --- TODO file ---
todo_json() {
    if [ -f "$TODO_FILE" ]; then
        jq -Rs '{path: $path, exists: true, content: .}' \
            --arg path "$TODO_FILE" < "$TODO_FILE"
    else
        jq -n '{path: $path, exists: false, content: null}' \
            --arg path "$TODO_FILE"
    fi
}

# --- Git logs (all repos + worktrees) ---
git_logs_json() {
    local repos
    repos=$(discover_repos)
    local first=true
    echo "["
    while IFS= read -r repo; do
        [ -z "$repo" ] && continue
        local name
        name=$(basename "$repo")

        # Collect commits from each worktree
        local worktrees
        worktrees=$(git -C "$repo" worktree list --porcelain 2>/dev/null | grep "^worktree " | sed 's/^worktree //')

        local wt_first=true
        local commits="["
        while IFS= read -r wt; do
            [ -z "$wt" ] && continue
            local branch
            branch=$(git -C "$wt" branch --show-current 2>/dev/null || echo "detached")
            local log
            log=$(git -C "$wt" log --since="${DATE}T00:00:00" --until="${DATE}T23:59:59" \
                --format='{"hash":"%h","subject":"%s","author":"%an","time":"%aI"}' \
                --all 2>/dev/null || true)
            if [ -n "$log" ]; then
                while IFS= read -r entry; do
                    $wt_first || commits+=","
                    wt_first=false
                    commits+=$(jq -c '. + {branch: $b, worktree: $wt}' \
                        --arg b "$branch" --arg wt "$wt" <<< "$entry")
                done <<< "$log"
            fi
        done <<< "$worktrees"
        commits+="]"

        # Skip repos with no commits today
        if [ "$commits" = "[]" ]; then
            continue
        fi

        $first || echo ","
        first=false
        jq -n '{name: $name, path: $path, commits: ($commits | fromjson)}' \
            --arg name "$name" --arg path "$repo" --arg commits "$commits"
    done <<< "$repos"
    echo "]"
}

# --- Session analysis ---
session_json() {
    local analyzer="$HOME/.claude/plugins/marketplaces/claude-plugins-official/plugins/session-report/skills/session-report/analyze-sessions.mjs"
    if [ -f "$analyzer" ] && command -v node &>/dev/null; then
        node "$analyzer" --json --since 1d 2>/dev/null || echo '{"error": "analyzer failed"}'
    else
        echo '{"error": "analyzer not available"}'
    fi
}

# --- MemPalace diary entries ---
mempalace_json() {
    if ! command -v mempalace &>/dev/null; then
        echo '{"error": "mempalace not installed"}'
        return
    fi

    # Search diary entries across all wings for today's date.
    # Run multiple searches: by date and by "SESSION:DATE" to maximize recall.
    # mempalace search is semantic, so we cast a wide net and filter by date.
    local raw
    raw=$(
        mempalace search "SESSION:$DATE" --room diary --results 20 2>/dev/null
        mempalace search "$DATE" --room diary --results 20 2>/dev/null
        mempalace search "CHECKPOINT:$DATE" --room diary --results 20 2>/dev/null
    )

    if [ -z "$raw" ]; then
        echo '{"entries": [], "message": "no diary results"}'
        return
    fi

    local tmpfile
    tmpfile=$(mktemp)
    printf '%s' "$raw" > "$tmpfile"
    trap "rm -f '$tmpfile'" RETURN

    # Parse the search output into structured JSON.
    # Each result block starts with "[N] wing / room" and content follows indented.
    python3 - "$DATE" "$tmpfile" <<'PYEOF'
import sys, json, re

target_date = sys.argv[1]
with open(sys.argv[2]) as f:
    text = f.read()
entries = []
blocks = re.split(r'\n  \[\d+\] ', text)
for block in blocks[1:]:  # skip header
    lines = block.strip().split('\n')
    if not lines:
        continue
    # First line: 'wing / room'
    loc = lines[0].strip()
    wing = loc.split('/')[0].strip() if '/' in loc else loc.strip()

    # Find content lines (after 'Match:' line, indented)
    content_lines = []
    past_match = False
    for line in lines[1:]:
        stripped = line.strip()
        if stripped.startswith('Match:'):
            past_match = True
            continue
        if stripped.startswith('Source:'):
            continue
        if past_match and stripped and not stripped.startswith('─') and not stripped.startswith('==='):
            content_lines.append(stripped)

    if content_lines:
        content = '\n'.join(content_lines)
        # Strip embedded search headers and trailing result boundaries
        content = re.sub(r'={5,}[\s\S]*?Results for:.*?={5,}', '', content)
        content = re.sub(r'\n\s*Results for:.*$', '', content, flags=re.MULTILINE)
        content = re.sub(r'\n\s*Room:.*$', '', content, flags=re.MULTILINE)
        content = content.strip()
        # Match date as an AAAK diary marker (SESSION:DATE, CHECKPOINT:DATE, or TEST:DATE)
        # not just any mention of the date string buried in noise
        td = re.escape(target_date)
        date_match = bool(re.search(
            rf'(?:SESSION|CHECKPOINT|TEST):{td}|^{td}\b',
            content, re.MULTILINE
        ))
        entries.append({
            'wing': wing,
            'content': content,
            'date_match': date_match,
        })

# Deduplicate (multiple searches may return the same entry)
seen = set()
unique = []
for e in entries:
    key = e['content'][:120]
    if key not in seen:
        seen.add(key)
        unique.append(e)

# Only include entries that contain today's date
dated = [e for e in unique if e['date_match']]
print(json.dumps({'entries': dated, 'total_searched': len(unique), 'date_filtered': len(dated)}))
PYEOF
}

# --- Assemble ---
{
    echo "{"
    echo "\"date\": $(jq -n --arg d "$DATE" '$d'),"
    echo "\"hostname\": $(jq -n --arg h "$HOST" '$h'),"
    echo "\"collected_at\": $(jq -n --arg t "$(date -Iseconds)" '$t'),"
    echo "\"todo\": $(todo_json),"
    echo "\"git_logs\": $(git_logs_json),"
    echo "\"sessions\": $(session_json),"
    echo "\"mempalace\": $(mempalace_json)"
    echo "}"
} | jq .
