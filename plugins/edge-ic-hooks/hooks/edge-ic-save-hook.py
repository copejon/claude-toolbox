#!/usr/bin/env python3
# Auto-checkpoint hook for edge-ic daily TODO updates.
#
# Stop hook that counts user messages in the session transcript.
# Every SAVE_INTERVAL messages, blocks the AI from stopping and
# returns a reason telling it to run the edge-ic daily-update command.
# On re-entry with stop_hook_active=true, lets the AI stop normally.

import json
import os
import re
import sys
from datetime import datetime
from pathlib import Path

SAVE_INTERVAL = 15
STATE_DIR = Path.home() / ".edge-ic" / "hook_state"
STATE_DIR.mkdir(parents=True, exist_ok=True)

LOG_FILE = STATE_DIR / "hook.log"


def log(msg):
    timestamp = datetime.now().strftime("%H:%M:%S")
    with open(LOG_FILE, "a") as f:
        f.write(f"[{timestamp}] {msg}\n")


def passthrough():
    print("{}")
    sys.exit(0)


# Opt-out: EDGE_IC_HOOKS_AUTO_UPDATE=false
auto_update = os.environ.get("EDGE_IC_HOOKS_AUTO_UPDATE", "")
if auto_update.lower() in ("false", "0", "no"):
    passthrough()

# Read hook input from stdin
raw_input = sys.stdin.read()

# Parse the hook payload
session_id = "unknown"
stop_hook_active = False
transcript_path = ""

try:
    data = json.loads(raw_input)
    session_id = re.sub(r"[^a-zA-Z0-9_/.\-~]", "", str(data.get("session_id", ""))) or "unknown"
    transcript_path = re.sub(r"[^a-zA-Z0-9_/.\-~]", "", str(data.get("transcript_path", "")))

    sha = data.get("stop_hook_active", False)
    stop_hook_active = sha is True or str(sha).lower() in ("true", "1", "yes")
except Exception:
    log("WARN: parse failed")
    err_file = STATE_DIR / "last_input.log"
    err_file.write_text(raw_input[:4096])
    err_file.chmod(0o600)

# Expand ~ in transcript path
if transcript_path.startswith("~"):
    transcript_path = str(Path.home()) + transcript_path[1:]

# Already in a save cycle — let through
if stop_hook_active:
    passthrough()

# Count user messages (skip tool results and slash commands)
exchange_count = 0
if transcript_path and os.path.isfile(transcript_path):
    with open(transcript_path) as f:
        for line in f:
            try:
                entry = json.loads(line)
                msg = entry.get("message", {})
                if isinstance(msg, dict) and msg.get("role") == "user":
                    content = msg.get("content", "")
                    # Only count plain text messages (real human input).
                    # Skip list content (tool results, multi-part system messages)
                    # and slash commands.
                    if not isinstance(content, str):
                        continue
                    if "<command-message>" in content:
                        continue
                    exchange_count += 1
            except Exception:
                pass

# Track last save point
last_save_file = STATE_DIR / f"{session_id}_last_save"
last_save = 0
if last_save_file.is_file():
    raw = last_save_file.read_text().strip()
    if raw.isdigit():
        last_save = int(raw)

since_last = exchange_count - last_save

log(f"Session {session_id}: {exchange_count} exchanges, {since_last} since last save")

if since_last >= SAVE_INTERVAL and exchange_count > 0:
    last_save_file.write_text(str(exchange_count))
    log(f"TRIGGERING TODO UPDATE at exchange {exchange_count}")

    print(json.dumps({
        "decision": "block",
        "reason": (
            "Edge-IC TODO checkpoint. Review the conversation since the last save "
            "and update today's daily TODO file (~/.daily/YYYY/MM/YYYY-MM-DD.md). "
            "For each outcome: mark completed items as [x], add progress notes to "
            "in-progress items, and append new tasks discovered. Show a short summary "
            "of changes. Continue conversation after updating."
        ),
    }))
else:
    passthrough()
