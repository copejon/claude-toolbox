#!/bin/bash
# Auto-checkpoint hook for edge-ic daily TODO updates.
#
# Stop hook that counts user messages in the session transcript.
# Every SAVE_INTERVAL messages, blocks the AI from stopping and
# returns a reason telling it to run the edge-ic daily-update command.
# On re-entry with stop_hook_active=true, lets the AI stop normally.

SAVE_INTERVAL=15
STATE_DIR="$HOME/.edge-ic/hook_state"
mkdir -p "$STATE_DIR"

PYTHON_BIN="${EDGE_IC_PYTHON:-}"
if [ -z "$PYTHON_BIN" ] || [ ! -x "$PYTHON_BIN" ]; then
    PYTHON_BIN="$(command -v python3 2>/dev/null || echo python3)"
fi

# Opt-out: EDGE_IC_HOOKS_AUTO_UPDATE=false
if [ -n "$EDGE_IC_HOOKS_AUTO_UPDATE" ]; then
    case "$EDGE_IC_HOOKS_AUTO_UPDATE" in
        false|0|no) echo "{}"; exit 0 ;;
    esac
fi

INPUT=$(cat)

_parsed=$(
    umask 077
    printf '%s' "$INPUT" | "$PYTHON_BIN" -c "
import sys, json, re
data = json.load(sys.stdin)
sid = data.get('session_id', '')
sha = data.get('stop_hook_active', False)
tp = data.get('transcript_path', '')
safe = lambda s: re.sub(r'[^a-zA-Z0-9_/.\-~]', '', str(s))
sha_str = 'True' if sha is True or str(sha).lower() in ('true', '1', 'yes') else 'False'
print('__PARSE_OK__')
print(safe(sid))
print(sha_str)
print(safe(tp))
" 2>"$STATE_DIR/last_python_err.log"
)

if [ -s "$STATE_DIR/last_python_err.log" ]; then
    chmod 600 "$STATE_DIR/last_python_err.log" 2>/dev/null
else
    rm -f "$STATE_DIR/last_python_err.log"
fi

_MARKER=$(printf '%s\n' "$_parsed" | sed -n '1p')
SESSION_ID=$(printf '%s\n' "$_parsed" | sed -n '2p')
STOP_HOOK_ACTIVE=$(printf '%s\n' "$_parsed" | sed -n '3p')
TRANSCRIPT_PATH=$(printf '%s\n' "$_parsed" | sed -n '4p')
SESSION_ID="${SESSION_ID:-unknown}"
STOP_HOOK_ACTIVE="${STOP_HOOK_ACTIVE:-False}"
TRANSCRIPT_PATH="${TRANSCRIPT_PATH:-}"

if [ -n "$INPUT" ] && [ "$_MARKER" != "__PARSE_OK__" ]; then
    echo "[$(date '+%H:%M:%S')] WARN: parse failed" >> "$STATE_DIR/hook.log"
    ( umask 077 && printf '%s' "$INPUT" | head -c 4096 > "$STATE_DIR/last_input.log" )
    chmod 600 "$STATE_DIR/last_input.log" 2>/dev/null
fi

TRANSCRIPT_PATH="${TRANSCRIPT_PATH/#\~/$HOME}"

# Already in a save cycle — let through
if [ "$STOP_HOOK_ACTIVE" = "True" ] || [ "$STOP_HOOK_ACTIVE" = "true" ]; then
    echo "{}"
    exit 0
fi

# Count user messages (skip slash commands)
if [ -f "$TRANSCRIPT_PATH" ]; then
    EXCHANGE_COUNT=$("$PYTHON_BIN" - "$TRANSCRIPT_PATH" <<'PYEOF'
import json, sys
count = 0
with open(sys.argv[1]) as f:
    for line in f:
        try:
            entry = json.loads(line)
            msg = entry.get('message', {})
            if isinstance(msg, dict) and msg.get('role') == 'user':
                content = msg.get('content', '')
                if isinstance(content, str) and '<command-message>' in content:
                    continue
                count += 1
        except:
            pass
print(count)
PYEOF
2>/dev/null)
else
    EXCHANGE_COUNT=0
fi

# Track last save point
LAST_SAVE_FILE="$STATE_DIR/${SESSION_ID}_last_save"
LAST_SAVE=0
if [ -f "$LAST_SAVE_FILE" ]; then
    LAST_SAVE_RAW=$(cat "$LAST_SAVE_FILE")
    if [[ "$LAST_SAVE_RAW" =~ ^[0-9]+$ ]]; then
        LAST_SAVE="$LAST_SAVE_RAW"
    fi
fi

SINCE_LAST=$((EXCHANGE_COUNT - LAST_SAVE))

echo "[$(date '+%H:%M:%S')] Session $SESSION_ID: $EXCHANGE_COUNT exchanges, $SINCE_LAST since last save" >> "$STATE_DIR/hook.log"

if [ "$SINCE_LAST" -ge "$SAVE_INTERVAL" ] && [ "$EXCHANGE_COUNT" -gt 0 ]; then
    echo "$EXCHANGE_COUNT" > "$LAST_SAVE_FILE"
    echo "[$(date '+%H:%M:%S')] TRIGGERING TODO UPDATE at exchange $EXCHANGE_COUNT" >> "$STATE_DIR/hook.log"

    cat << 'HOOKJSON'
{
  "decision": "block",
  "reason": "Edge-IC TODO checkpoint. Review the conversation since the last save and update today's daily TODO file (~/.daily/YYYY/MM/YYYY-MM-DD.md). For each outcome: mark completed items as [x], add progress notes to in-progress items, and append new tasks discovered. Show a short summary of changes. Continue conversation after updating."
}
HOOKJSON
else
    echo "{}"
fi
