# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A Claude Code plugin marketplace — a collection of personal plugins that extend Claude Code sessions via hooks and skills. The marketplace manifest at `.claude-plugin/marketplace.json` registers all plugins and is what Claude Code reads to discover them.

## Architecture

```
.claude-plugin/marketplace.json        ← marketplace manifest (lists all plugins)
plugins/<name>/.claude-plugin/plugin.json  ← per-plugin metadata (name, version, author)
```

Plugins can contain two types of extensions:

**Hook-based plugins** (e.g., `time-keeper`): run shell commands in response to Claude Code events.
```
plugins/<name>/hooks/hooks.json    ← hook definitions (event → command)
plugins/<name>/hooks/*.sh          ← hook scripts
```
Hooks are keyed by event name (e.g., `SessionStart`). Each entry specifies `type` (`command`), a `command` string, and a `timeout` in seconds. Scripts reference `${CLAUDE_PLUGIN_ROOT}` to locate their own directory at runtime.

**Skill-based plugins** (e.g., `todoist-sync`, `aws-stack`): prompt-driven skills invoked as slash commands.
```
plugins/<name>/skills/<skill>/SKILL.md  ← skill definition (frontmatter + instructions)
```
SKILL.md files use YAML frontmatter with `name`, `description`, `argument-hint`, `user-invocable`, and `allowed-tools`. The body contains the full prompt instructions.

## Adding a New Plugin

1. Create `plugins/<name>/.claude-plugin/plugin.json` with name, version, description, author, license.
2. For hook plugins: create `hooks/hooks.json` and hook scripts.
3. For skill plugins: create `skills/<skill>/SKILL.md` with frontmatter and instructions.
4. Register the plugin in `.claude-plugin/marketplace.json` under the `plugins` array.
