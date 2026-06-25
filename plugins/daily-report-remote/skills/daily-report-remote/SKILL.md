---
name: daily-report-remote
description: Collect daily report data from remote server (lab-proxy) via SSH — git logs, TODO file — and generate a deterministic Slack-ready daily standup report
argument-hint: "[YYYY-MM-DD] [--collect-only]"
user-invocable: true
allowed-tools:
  - Bash(${CLAUDE_PLUGIN_ROOT}/bin/daily-report.sh *)
  - Read
  - AskUserQuestion
---

# Remote Daily Report

Collect daily report data from the remote development server and generate a Slack-ready daily standup report. Complements `edge-ic:daily-report` by pulling data from the server where most development work happens.

## Prerequisites

- SSH access to `lab-proxy` (configured in `~/.ssh/config`)

## Task

1. **Collect remote data** via the wrapper script
2. **Format** into a deterministic Slack report
3. **Review** with user and finalize

## Instructions

### Step 1 — Determine the date

Use `$ARGUMENTS` if a date was provided (e.g. `2026-06-01`). Otherwise default to today: `date +%Y-%m-%d`.

### Step 2 — Collect data from remote server

```bash
${CLAUDE_PLUGIN_ROOT}/bin/daily-report.sh collect YYYY-MM-DD
```

This SSHes to `lab-proxy`, runs the collection script, and saves JSON to `/tmp/remote-daily-data-YYYY-MM-DD.json`.

If collection fails, report the error and stop. Do not fabricate data.

If `--collect-only` is present in `$ARGUMENTS`, display a summary of the collected JSON and stop here.

### Step 3 — Format the report

```bash
${CLAUDE_PLUGIN_ROOT}/bin/daily-report.sh format YYYY-MM-DD
```

This produces:
- `/tmp/daily-report-YYYY-MM-DD.txt` — the deterministic Slack-formatted report
- `/tmp/daily-report-YYYY-MM-DD-suggestions.txt` — commits found in git but not in the TODO file

### Step 4 — Validate format

```bash
${CLAUDE_PLUGIN_ROOT}/bin/daily-report.sh validate YYYY-MM-DD
```

If validation fails, read the report file and describe the errors. Do not attempt to fix the report directly — the formatter script owns the output format.

### Step 5 — Review with user

Read the report from `/tmp/daily-report-YYYY-MM-DD.txt` and present it to the user.

If `/tmp/daily-report-YYYY-MM-DD-suggestions.txt` is non-empty, read it and present the uncaptured commits separately:
- "These commits were found in git but aren't reflected in the TODO file. Would you like to add any as report items?"

Ask:
- Are there additional items to include?
- Should any bullets be revised or consolidated?
- Ready to finalize?

### Step 6 — Offer follow-up actions

After the report is accepted, offer:
- "Run `edge-ic:daily-report` locally to compare/merge?"
- "Update any Jira tickets based on today's progress?"

## Important

- **Do not fabricate data.** Only report what the collection and formatting scripts return.
- **The TODO file is the primary source.** Git logs are supplementary — they catch things the TODO might have missed.
- **Do not reformat the report.** The formatter script produces deterministic output. Only add user-approved items.
- **Jira ticket format**: `TICKET-ID: Description (https://redhat.atlassian.net/browse/TICKET-ID)`
