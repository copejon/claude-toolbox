---
name: roll-call
description: "This skill should be used when the user wants to list, browse, or check which multi-persona councils or persona prompts are available. Triggers on 'roll call', 'list councils', 'list personas', 'show my councils', 'which councils', 'available personas', or 'what councils do I have'."
user-invocable: true
version: 1.0.0
allowed-tools:
  - Read
  - Bash
---

# Roll Call

List all available multi-persona councils across session, user, and project scopes.

## Process

### Discover

Search three locations for persona prompt files:

1. **Session** (tmp): glob `/tmp/persona-*.md`
2. **User-level agents**: glob `~/.claude/agents/persona-*.md`
3. **Project-level agents**: glob `.claude/agents/persona-*.md`

For each file found, read the YAML frontmatter to extract:
- `title` (or `name` for agent files)
- `created` date (if present)
- `personas` list (or parse role names from `description` for agent files)

### Present

Display a summary table with all discovered councils:

```
| Council | Scope | Personas | Created |
|---------|-------|----------|---------|
| Cloud Migration Strategy Council | session | CTO, CFO, Lead Engineer | 2026-07-22 |
| Product Launch Risk Council | user-agent | PM, Legal, Marketing | 2026-07-15 |
```

If no councils are found, report that and suggest running `/forge-the-council` to create one.

After listing, remind the user:
- `/forge-the-council` to create a new council
- `/convene-the-council "question"` to run an analysis with one
