---
name: todoist-sync
description: Sync Jira tickets into the Red Hat Work Todoist project. One-way sync — Jira is source of truth. Handles priority assignment, section placement, sprint deadlines, and drift detection. Use /todoist-sync review (default) for read-only comparison or /todoist-sync apply to make changes.
argument-hint: <review|apply>
user-invocable: true
allowed-tools:
  - mcp__jira__jira_get_issue
  - mcp__jira__jira_search
  - mcp__jira__jira_get_agile_boards
  - mcp__jira__jira_get_sprints_from_board
  - mcp__jira__jira_get_board_issues
  - mcp__todoist__get-overview
  - mcp__todoist__find-projects
  - mcp__todoist__find-tasks
  - mcp__todoist__add-tasks
  - mcp__todoist__update-tasks
  - mcp__todoist__reschedule-tasks
  - mcp__todoist__complete-tasks
  - mcp__todoist__add-sections
  - mcp__todoist__update-sections
---

# Jira → Todoist Sync

## Mode

- If `$ARGUMENTS` is empty or "review" → run Steps 1–4 only (read-only comparison). Present drift table and proposed changes. Do NOT make any changes.
- If `$ARGUMENTS` is "apply" → run Steps 1–8 (full sync). Still present the comparison first and get user approval before applying.

## Ground Rules

- **One-way sync only** — Jira is the source of truth. NEVER alter Jira to reflect Todoist.
- **Never make a Todoist change without user approval.**
- **Only operate on the #Red Hat Work project** (ID: `6gRPWF9H5qxHgqCg`).

---

## Sync Procedure

### Step 1: Gather current state (parallel calls)

1. Fetch Todoist project overview (all sections + tasks)
2. Extract Jira ticket keys from existing Todoist task content/descriptions
3. For each referenced ticket, fetch from Jira: **issue type**, status, priority, assignee
4. Search Jira for open tickets assigned to user: `assignee = currentUser() AND status not in (Closed, Done, Resolved) AND project in (USHIFT, OCPSTRAT)`

### Step 2: Identify the current sprint

1. Get active sprint from the OpenShift Edge Scrum board (ID: `11479`)
2. Record the sprint end date — this becomes the **deadline** for sprint-sourced Todoist tasks
3. Query which of the user's assigned tickets are in this sprint

### Step 3: Filter by issue type — BEFORE priority

Always check issue type first. This is the most common mistake to avoid.

| Issue Type | Treatment |
|------------|-----------|
| Feature, Epic | p4 tracking only, or skip entirely — never promote |
| Story, Spike, Task, Bug, Sub-task | Sync and prioritize per Step 5 |

### Step 4: Compare Todoist vs Jira and identify drift

**Existing Todoist tasks (backed by Jira):**
- Jira ticket now **Closed/Done** → suggest completing in Todoist
- Jira **status changed** → flag for user, may affect priority
- Sprint ticket **missing deadline** → set deadline = sprint end
- Sprint ticket has a **due date it shouldn't** → clear it (due dates are for daily planning, not sprint tracking)

**Jira tickets missing from Todoist:**
- In current sprint + assigned to user → propose adding
- In backlog + assigned to user or user is SME → propose adding at p4
- Not assigned and not in sprint → skip

**Duplicate detection:** Before creating a new task, check existing Todoist tasks for semantic overlap (same scope, different wording). Jira-backed tasks take precedence over manually created ones.

**If mode is "review", STOP HERE.** Present the drift table and proposed changes. Do not proceed to Steps 5–8.

---

### Step 5: Assign Todoist priority

Priority reflects **daily intent and accountability** — what the user should iterate on today. It is NOT a mapping from Jira status or Jira priority fields.

| Priority | Meaning | Assign when... |
|----------|---------|----------------|
| **p1** | Highest focal points — work on some today | Key results work, active feature work, critical/blocker bugs. Things the user is most personally responsible for. |
| **p2** | Normal priority — today or tomorrow | PR/docs reviews, non-critical and non-blocking bugs. Routine professional obligations. |
| **p3** | Sprint remainder — plan a day, 1-2 hrs | Other sprint work not yet started. Small scope, time-boxable. |
| **p4** | Backlog ownership — remember, no urgency | Backlog tickets (assigned or SME), blocked items, Feature/Epic tracking, meta/tracking tasks. |

### Step 6: Assign section

Sections are workstream-based. New Jira tickets slot into the workstream they belong to. Sections evolve as workstreams change — check the current project structure before assigning. Common patterns:

- **Bug** → Bug Fixes
- **Rebase or CI operational duty** → Rebase & CI Ops
- **Work under a tracked epic** → that epic's dedicated section (if one exists)
- **Recurring daily tasks** → Routines
- **Sprint card, sprint tracking** → Sprint Meta

**Special sections not sourced from Jira:**
- **Key Results** — calendar-year scope, self-paced, tracked exclusively in Todoist. Never sync from Jira. Section is named by year (e.g., "2026 Key Results").

### Step 7: Set dates

| Date type | Purpose | Rule |
|-----------|---------|------|
| **Deadline** | Sprint boundary (immovable) | Set to sprint end date for all sprint-sourced tasks |
| **Due date** | Daily planning (flexible) | Leave unset on sync. User sets to "today" when pulling into their daily plan. |
| **Neither** | Backlog / Key Results | No deadline, no due date. User manages at their own pace. |

### Step 8: Present changes and get approval

Show a comparison table of all proposed changes (additions, priority changes, completions, date fixes). Group by change type. Wait for explicit approval before applying.

---

## Daily Planning Workflow (context)

This is how the user plans their day — context for why the sync rules work the way they do.

1. **Estimate effort** → add pomodoro label (1-5 pomodoros)
2. **Pull into day** → set due date to "today"
3. **"Today's Pomodoros"** filter (pomodoro label & Today) → daily workload, auto-sorted by priority (p1 at top)
4. **"Ripening Pomodoros"** filter (pomodoro label & No Date) → estimated but unscheduled work, ready to pull
5. **End of day** → reschedule incomplete tasks to next work day; deadline stays untouched

---

## Pitfalls

Check for each of these during every sync.

1. **Skipping the issue type check.** The type filter (Step 3) must run before priority assignment. A Feature ticket should never be promoted above p4 regardless of how important it looks.

2. **Mapping priority from Jira status.** "In Progress" doesn't mean p2. "To Do" doesn't mean p3. Priority reflects what the user is accountable for and should iterate on today — not where the ticket sits in a workflow.

3. **Creating duplicates.** A manually created Todoist subtask may cover the same scope as a Jira-backed ticket with different wording. Always check for semantic overlap before adding.

4. **Forgetting deadlines.** Without a Todoist deadline, rescheduling a task to "today" erases the sprint boundary. Sprint tasks must have deadline = sprint end so the constraint persists through daily planning.

5. **Over-syncing.** Don't add every open Jira ticket. Filter to: current sprint members (at appropriate priority) + backlog tickets where user is assignee or SME (at p4). Everything else is noise.

6. **Touching Key Results.** These are calendar-year, self-paced, Todoist-only. They are never sourced from Jira and should not be modified during a sync operation.
