#!/usr/bin/env bash
# audit-remote-layout.sh — Discover plugin paths, repos, and tools on this host.
# Outputs JSON to stdout AND writes to ~/.daily-report-remote-audit.json.
set -euo pipefail

HOST="$(hostname -s)"
TIMESTAMP="$(date -Iseconds)"

# --- 1. Plugin directories ---
plugin_dirs_json() {
    local first=true
    echo "["
    while IFS= read -r dir; do
        [ -z "$dir" ] && continue
        local contents
        contents=$(ls -1 "$dir" 2>/dev/null | jq -R . | jq -s .)
        $first || echo ","
        first=false
        jq -n --arg path "$dir" --argjson contents "$contents" \
            '{path: $path, contents: $contents}'
    done < <(find "$HOME" -maxdepth 4 -type d -name "plugins" -path "*/.claude/*" 2>/dev/null)
    echo "]"
}

# --- 2. Locate collect-daily-data.sh ---
collect_script_json() {
    local first=true
    echo "["
    while IFS= read -r f; do
        [ -z "$f" ] && continue
        local line1
        line1=$(head -1 "$f" 2>/dev/null || echo "unreadable")
        $first || echo ","
        first=false
        jq -n --arg path "$f" --arg first_line "$line1" \
            '{path: $path, first_line: $first_line}'
    done < <(find "$HOME" -maxdepth 8 -name "collect-daily-data.sh" 2>/dev/null)
    echo "]"
}

# --- 3. Locate analyze-sessions.mjs ---
analyzer_json() {
    local results
    results=$(find "$HOME" -maxdepth 8 -name "analyze-sessions.mjs" 2>/dev/null || true)
    if [ -z "$results" ]; then
        echo "[]"
    else
        echo "$results" | jq -R . | jq -s .
    fi
}

# --- 4. Repo roots ---
repo_root_json() {
    local path="$1"
    local exists=false is_git=false
    local worktrees="[]" children="[]"

    if [ -d "$path" ]; then
        exists=true
        if [ -d "$path/.git" ] || [ -f "$path/.git" ]; then
            is_git=true
            worktrees=$(git -C "$path" worktree list --porcelain 2>/dev/null \
                | grep "^worktree " | sed 's/^worktree //' \
                | jq -R . | jq -s . || echo "[]")
        else
            local cfirst=true
            children="["
            for child in "$path"/*/; do
                [ -d "$child" ] || continue
                local cname cpath cis_git=false cwt="[]"
                cname=$(basename "$child")
                cpath="${child%/}"
                if [ -d "$cpath/.git" ] || [ -f "$cpath/.git" ]; then
                    cis_git=true
                    cwt=$(git -C "$cpath" worktree list --porcelain 2>/dev/null \
                        | grep "^worktree " | sed 's/^worktree //' \
                        | jq -R . | jq -s . || echo "[]")
                fi
                $cfirst || children+=","
                cfirst=false
                children+=$(jq -n --arg name "$cname" --arg path "$cpath" \
                    --argjson is_git "$cis_git" --argjson worktrees "$cwt" \
                    '{name: $name, path: $path, is_git_repo: $is_git, worktrees: $worktrees}')
            done
            children+="]"
        fi
    fi

    jq -n --arg path "$path" \
        --argjson exists "$exists" --argjson is_git "$is_git" \
        --argjson worktrees "$worktrees" --argjson children "$children" \
        '{path: $path, exists: $exists, is_git_repo: $is_git, worktrees: $worktrees, children: $children}'
}

repo_roots_json() {
    local roots=("$HOME/microshift"
                 "$HOME/Workspace/github.com/openshift"
                 "$HOME/Workspace/github.com/copejon"
                 "$HOME/Workspace/claude")
    local first=true
    echo "["
    for r in "${roots[@]}"; do
        $first || echo ","
        first=false
        repo_root_json "$r"
    done
    echo "]"
}

# --- 5. TODO structure ---
todo_json() {
    local base="$HOME/.daily"
    local exists=false recent="[]"
    if [ -d "$base" ]; then
        exists=true
        recent=$(find "$base" -name "*.md" -type f 2>/dev/null | sort | tail -5 | jq -R . | jq -s .)
    fi
    jq -n --arg base "$base" --argjson exists "$exists" --argjson recent "$recent" \
        '{base_path: $base, exists: $exists, recent_files: $recent}'
}

# --- 6. Tools ---
tool_check() {
    local name="$1"
    local ver_cmd="${2:-$1 --version}"
    local p v
    p=$(which "$name" 2>/dev/null || true)
    if [ -n "$p" ]; then
        v=$(eval "$ver_cmd" 2>/dev/null | head -1 || echo "unknown")
        jq -n --argjson available true --arg version "$v" --arg path "$p" \
            '{available: $available, version: $version, path: $path}'
    else
        echo '{"available": false, "version": null, "path": null}'
    fi
}

tools_json() {
    local py node jq_tool git mp
    py=$(tool_check python3 "python3 --version")
    node=$(tool_check node "node --version")
    jq_tool=$(tool_check jq "jq --version")
    git=$(tool_check git "git --version")
    mp=$(tool_check mempalace "mempalace --version")
    jq -n --argjson python3 "$py" --argjson node "$node" \
        --argjson jq "$jq_tool" --argjson git "$git" --argjson mempalace "$mp" \
        '{python3: $python3, node: $node, jq: $jq, git: $git, mempalace: $mempalace}'
}

# --- Assemble ---
output=$(
    {
        echo "{"
        echo "\"hostname\": $(jq -n --arg h "$HOST" '$h'),"
        echo "\"os\": $(jq -n --arg o "$(uname -a)" '$o'),"
        echo "\"collected_at\": $(jq -n --arg t "$TIMESTAMP" '$t'),"
        echo "\"plugin_directories\": $(plugin_dirs_json),"
        echo "\"collect_daily_data_locations\": $(collect_script_json),"
        echo "\"analyze_sessions_locations\": $(analyzer_json),"
        echo "\"repo_roots\": $(repo_roots_json),"
        echo "\"todo_structure\": $(todo_json),"
        echo "\"tools\": $(tools_json)"
        echo "}"
    } | jq .
)

echo "$output"
echo "$output" > "$HOME/.daily-report-remote-audit.json"
echo "Written to $HOME/.daily-report-remote-audit.json" >&2
