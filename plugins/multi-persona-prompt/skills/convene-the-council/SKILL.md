---
name: convene-the-council
description: "This skill should be used when the user wants to run a multi-persona analysis, ask personas a question, execute a previously synthesized multi-persona prompt, or get adversarial stakeholder perspectives on a question. Discovers saved councils and deploys a subagent to produce a full adversarial analysis. Triggers on 'ask the personas', 'ask my personas', 'run persona analysis', 'what do the personas think', 'stakeholder analysis on', 'persona perspective', 'convene the council', or 'convene my council'."
argument-hint: "<question or prompt for the council>"
user-invocable: true
version: 1.0.0
allowed-tools:
  - Read
  - Bash
  - Agent
  - AskUserQuestion
---

# Convene the Council

Load a previously forged council of personas, combine it with the user's question, and deploy a subagent that performs the full adversarial multi-persona analysis.

## Invocation

```
/convene-the-council "What approach should we take for migrating to microservices?"
```

The user's question is passed as the skill argument (`$ARGUMENTS`).

## Process Flow

1. **Discover**: Search tmp, user-level agents, and project-level agents for councils
2. **Select**: If none found → suggest `/forge-the-council`. Otherwise → present choices to user
3. **Assemble**: Load selected prompt, combine with user's question using the combined-prompt structure
4. **Deploy**: Dispatch subagent with the assembled prompt
5. **Return**: Present the subagent's analysis to the user

## Step 1 — Discover Available Councils

Search three locations for persona prompt files:

1. **Session-scoped** (tmp): glob `/tmp/persona-*.md`
2. **User-level agents**: glob `~/.claude/agents/persona-*.md`
3. **Project-level agents**: glob `.claude/agents/persona-*.md`

For each file found, read the YAML frontmatter to extract the `title` (or `name` for agent files) and `personas` list (or `description` for agent files).

If no councils are found, inform the user and suggest running `/forge-the-council` first. Stop here.

## Step 2 — Present Choices

Present the full list of discovered councils to the user. For each option, display:
- The council's **title/name** (e.g., "Cloud Migration Strategy Council")
- **Source**: session / user-agent / project-agent
- **Persona roles**: the stakeholder names from the file

Let the user select which council to convene. If only one exists, confirm it rather than auto-selecting — the user may want to forge a different one instead.

## Step 3 — Load and Combine

Read the selected prompt file. Extract the multi-persona prompt body (everything after the YAML frontmatter).

Assemble the subagent prompt using this structure:

```
You are executing a multi-persona adversarial analysis. Below is your persona
framework — it defines the stakeholders, their roles and mandates, the
interaction protocol, output format, and quality controls. Follow it exactly.

--- PERSONA FRAMEWORK START ---
<the full multi-persona prompt body from the selected file>
--- PERSONA FRAMEWORK END ---

--- ANALYSIS SUBJECT ---
Analyze the following question through each persona's lens, then follow the
interaction protocol to produce cross-persona dialogue and a synthesized
recommendation:

<the user's question from $ARGUMENTS>
--- END ---
```

## Step 4 — Deploy Subagent

Dispatch a subagent using the Agent tool with:
- **description**: "Convening council: \<title\>"
- **prompt**: the assembled prompt from Step 3

The subagent executes the full multi-persona analysis and returns its output.

## Step 5 — Return Results

Present the subagent's analysis to the user. The output follows the format specified in the multi-persona prompt (position statements, detailed analyses, cross-persona dialogue, synthesized recommendation).

Present the subagent's output directly without post-processing.

## Error Handling

- **File unreadable or malformed frontmatter**: Skip the file during discovery. If the user selected it, report the error and offer to re-discover or forge a new council.
- **Subagent failure or timeout**: Report the error to the user. Suggest retrying or adjusting the question scope.
- **Empty `$ARGUMENTS`**: Ask the user what question they want the council to analyze before proceeding.
