#!/usr/bin/env bash
# collect-daily-data.sh — Gather daily report data from this host and emit JSON.
#
# Usage: collect-daily-data.sh [YYYY-MM-DD]
#   Defaults to today's date if not specified.
#
# Output: JSON object with todo and git_logs fields to stdout.
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

# --- Assemble ---
{
    echo "{"
    echo "\"date\": $(jq -n --arg d "$DATE" '$d'),"
    echo "\"hostname\": $(jq -n --arg h "$HOST" '$h'),"
    echo "\"collected_at\": $(jq -n --arg t "$(date -Iseconds)" '$t'),"
    echo "\"todo\": $(todo_json),"
    echo "\"git_logs\": $(git_logs_json)"
    echo "}"
} | jq .
