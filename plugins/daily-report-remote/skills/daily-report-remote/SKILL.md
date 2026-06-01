---
name: daily-report-remote
description: Collect daily report data from remote server (lab-proxy) via SSH — git logs, TODO file, session stats — and generate an enhanced Slack-ready daily standup report
argument-hint: "[YYYY-MM-DD] [--collect-only]"
user-invocable: true
allowed-tools:
  - Bash
  - Read
  - Write
  - Edit
  - AskUserQuestion
---

# Remote Daily Report

Collect daily report data from the remote development server and generate an enhanced Slack-ready daily standup report. Complements `edge-ic:daily-report` by pulling data from the server where most development work happens.

## Prerequisites

- SSH access to `lab-proxy` (configured in `~/.ssh/config`)
- The collection script at `~/.claude/plugins/marketplaces/claude-toolbox/plugins/daily-report-remote/bin/collect-daily-data.sh` on the remote host

## Task

1. **Collect remote data** via SSH
2. **Parse and enrich** the data into a daily standup report
3. **Output** in Slack-ready format

## Instructions

### Step 1 — Determine the date

Use `$ARGUMENTS` if a date was provided (e.g. `2026-06-01`). Otherwise default to today: `date +%Y-%m-%d`.

If `--collect-only` is present, skip report generation — just collect and display the raw data summary.

### Step 2 — Collect data from remote server

Run the collection script on `lab-proxy` via SSH:

```bash
ssh lab-proxy 'bash ~/.claude/plugins/marketplaces/claude-toolbox/plugins/daily-report-remote/bin/collect-daily-data.sh YYYY-MM-DD' 2>/dev/null
```

Save the JSON output to `/tmp/remote-daily-data-YYYY-MM-DD.json`.

If SSH fails, report the error and stop. Do not fabricate data.

### Step 3 — Parse the collected data

Read `/tmp/remote-daily-data-YYYY-MM-DD.json` and extract:

**From `todo`** (the daily TODO file on the server):
- All `- [x]` items → completed work
- All `- [ ]` items under "In Progress" → in-progress work
- All items with blocker notes → blocked items
- Jira ticket references (e.g. `USHIFT-1234`, `OCPEDGE-567`)

**From `git_logs`** (commits across all repos and worktrees):
- Group commits by repo name
- Identify commits that correspond to TODO items (match by Jira ticket or description)
- Flag commits NOT reflected in the TODO file — these are potential missing items
- Note: worktree and branch info is included per commit

**From `sessions`** (Claude Code session analysis):
- `overall.human_messages` — conversation volume
- `overall.hours.active` — active working time
- `by_project` — which projects were worked on
- `by_skill` — which skills/commands were used
- Notable session activity that indicates work not captured in the TODO

**From `mempalace`** (diary entries across all wings):
- Entries are in AAAK compressed format — decode the pipe-delimited fields
- Diary entries capture work that may not appear in git or the TODO file (architecture discussions, debugging sessions, research, decisions)
- `date_match: true` entries are from today; others are semantic search matches that may be less relevant
- Cross-reference with TODO items — diary entries often capture context and decisions behind the work

### Step 4 — Generate the enhanced daily report

Follow the same Slack format as `edge-ic:daily-report`:

```text
Daily Report:

:done-circle-check: Completed item description
:done-circle-check: TICKET-123: Completed with ticket (https://redhat.atlassian.net/browse/TICKET-123)
:in-progress: In-progress item
:jira-blocker: Blocked item with reason
```

**Enhancements over the basic daily-report:**

1. **Cross-reference TODO with git**: If a TODO item has matching commits, note the repos/branches. If commits exist with NO corresponding TODO item, add them as discovered work.

2. **Session context**: If session data shows significant work in a project not reflected in the TODO, flag it as a potential addition.

3. **Consolidation**: Group related items. Combine multiple Jira tickets for the same work into one bullet.

### Step 5 — Validate format

If the validation script is available locally:
```bash
plugins/edge-ic/bin/validate-daily-report.sh /tmp/daily-report-YYYY-MM-DD.txt
```

If not available locally (running on MacBook without edge-tooling), validate manually:
- Header line present ("Daily Report:")
- Only `:done-circle-check:`, `:in-progress:`, `:jira-blocker:` emojis used
- No markdown formatting (no code blocks, no checkboxes)
- Plain text ready for Slack
- Jira URLs use format: `https://redhat.atlassian.net/browse/TICKET-ID`

### Step 6 — Review with user

Present the report and ask:
- Are there additional items to include?
- Should any bullets be revised or consolidated?
- Ready to finalize?

Write the final report to `/tmp/daily-report-YYYY-MM-DD.txt`.

### Step 7 — Offer follow-up actions

After the report is accepted, offer:
- "Run `edge-ic:daily-report` locally to compare/merge?"
- "Update any Jira tickets based on today's progress?"
- "Update the remote TODO file with any new items discovered?"

## Important

- **Do not fabricate data.** Only report what the collection script returns.
- **The TODO file is the primary source.** Git logs and session data are supplementary — they catch things the TODO might have missed.
- **Consolidate aggressively.** A daily report should have 3-8 bullets, not 15.
- **Jira ticket format**: `TICKET-ID: Description (https://redhat.atlassian.net/browse/TICKET-ID)`
