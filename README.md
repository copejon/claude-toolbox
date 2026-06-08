# claude-toolbox

A personal collection of [Claude Code](https://claude.ai/code) plugins, packaged as a `claude-plugin` marketplace.

## Plugins

| Plugin | Version | Description | Hook |
|--------|---------|-------------|------|
| [time-keeper](plugins/time-keeper) | 1.0.0 | Injects current date/time into every session at startup | `SessionStart` |

## Project Structure

```
.claude-plugin/
  marketplace.json        # Plugin registry — all plugins must be listed here
plugins/
  <name>/
    plugin.json           # Metadata (name, version, description, author, license)
    hooks/
      hooks.json          # Maps lifecycle events to shell commands
      *.sh                # Hook scripts
```

## Creating a Plugin

1. Create the plugin directory and metadata:

   ```json
   // plugins/my-plugin/plugin.json
   {
     "name": "my-plugin",
     "version": "1.0.0",
     "description": "What it does",
     "author": { "name": "jcope" },
     "license": "MIT"
   }
   ```

2. Define which lifecycle events to hook into:

   ```json
   // plugins/my-plugin/hooks/hooks.json
   {
     "description": "Short description",
     "hooks": {
       "SessionStart": [
         {
           "hooks": [
             {
               "type": "command",
               "command": "bash \"${CLAUDE_PLUGIN_ROOT}/hooks/my-script.sh\"",
               "timeout": 5
             }
           ]
         }
       ]
     }
   }
   ```

   `${CLAUDE_PLUGIN_ROOT}` resolves to the plugin's directory at runtime.

3. Add your hook scripts in `plugins/my-plugin/hooks/`.

4. Register the plugin in `.claude-plugin/marketplace.json`:

   ```json
   {
     "name": "my-plugin",
     "source": "./plugins/my-plugin",
     "description": "What it does"
   }
   ```

## License

MIT
