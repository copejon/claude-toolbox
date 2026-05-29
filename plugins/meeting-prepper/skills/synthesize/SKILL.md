---
name: synthesize
description: Synthesize a status briefing from GitHub PRs and linked Jira tickets for a community meeting. Gathers merged/open PRs from configured repos, follows Jira links in PR comments, and produces a concise briefing file.
argument-hint: [--since YYYY-MM-DD] [--repos org/repo,org/repo]
user-invocable: true
allowed-tools:
  - Bash
  - WebFetch
  - WebSearch
  - Read
  - Write
  - mcp__jira__jira_get_issue
---

# Meeting Briefing Synthesizer

Synthesize a briefing for a status update meeting. The briefing informs community members (engineers and product managers) on the status of a project based on recent GitHub PR activity and linked Jira context.

## Default Configuration

| Setting | Default |
|---------|---------|
| Repositories | `openshift/microshift`, `microshift-io/microshift` |
| Since date | 2 weeks ago |
| Output dir | current working directory |

Override via `$ARGUMENTS`:
- `--since YYYY-MM-DD` — custom date range start
- `--repos org/repo,org/repo` — comma-separated repo list

## Workflow

### Step 1: Gather PRs

Use `gh` to query each repository for PRs merged or opened since the target date:

```bash
gh pr list --repo <org/repo> --state merged --search "merged:>YYYY-MM-DD" --json number,title,body,comments,url,author,mergedAt --limit 100
gh pr list --repo <org/repo> --state open --json number,title,body,url,author,createdAt --limit 50
```

### Step 2: Extract Jira Links

Scan PR bodies and comments for Jira ticket references. Tickets are typically in the format `https://issues.redhat.com/browse/USHIFT-XXXX` or bare keys like `USHIFT-1234`, `OCPBUGS-1234`.

Tickets are typically 1:1 with PRs. Do not assume a Jira ticket corresponds to multiple PRs unless the ticket explicitly links to multiple PRs.

### Step 3: Fetch Jira Context

For each referenced ticket, fetch summary, status, priority, and assignee via the Jira MCP tools. If a ticket is not publicly accessible, note it and move on — the user will provide additional context if needed.

### Step 4: Synthesize Briefing

Group PRs by topic/component and synthesize a concise, readable briefing. For each topic:
- What changed (1-2 sentences per PR)
- Jira context (ticket status, why this work matters)
- Any notable open items or follow-ups

Closed PRs should generally be ignored unless they appear relevant (abandoned work that signals direction changes).

### Step 5: Write Output

Write the briefing to a date-stamped file in the output directory:
```
briefing-YYYY-MM-DD.md
```

Filenames must sort lexicographically into chronological order.

## Output Format

Deliver a concise, readable briefing suitable for reading aloud. Avoid jargon where possible. Structure:

```markdown
# Status Briefing — YYYY-MM-DD

## Summary
<2-3 sentence overview of the period>

## Merged Work
### <Topic/Component>
- **PR #N**: <title> — <1 sentence summary>. (<JIRA-KEY>: <ticket status>)

## In Progress
### <Topic/Component>
- **PR #N**: <title> — <1 sentence summary>. (<JIRA-KEY>: <ticket status>)

## Notable Items
- <Anything worth calling out: blocked work, direction changes, upcoming milestones>
```

## Rules

- It is okay not to know something. If you do not know and the answer is not in the context, say so and ask for help.
- Do not assume a Jira ticket corresponds to multiple PRs unless explicitly linked.
- Closed (not merged) PRs should be ignored unless they signal a relevant direction change.
