#!/usr/bin/env python3
# Hook for edge-ic daily TODO updates.
# Fires on PreCompact (auto only) — blocks and tells the AI to update the daily TODO.

import json
import os
import sys


def passthrough():
    print("{}")
    sys.exit(0)


# Opt-out: EDGE_IC_HOOKS_AUTO_UPDATE=false
auto_update = os.environ.get("EDGE_IC_HOOKS_AUTO_UPDATE", "")
if auto_update.lower() in ("false", "0", "no"):
    passthrough()

raw_input = sys.stdin.read()

try:
    data = json.loads(raw_input)
except Exception:
    data = {}

# Only block on auto-compaction, not manual /compact
if data.get("trigger") == "manual":
    passthrough()

if data.get("stop_hook_active") in (True, "true", "1", "yes"):
    passthrough()

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
