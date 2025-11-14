# n8n CLI Tool

A command-line tool to manage n8n workflows and executions locally.

## 🤖 For Non-Developers (AI Agent Mode)

**Got a broken n8n workflow? Just tell an AI agent:**

```
You: "My Todoist Notion Sync workflow is failing, please fix it"

AI: 🔍 Searching for workflow...
    📥 Pulling workflow and error logs...
    🔬 Analyzing execution data...
    ✏️  Fixing configuration issue in "Create page" node...
    ✅ Validated and pushed fix to n8n!
```

**That's it.** The agent does everything automatically - no coding required.

**What the agent does behind the scenes:**
1. Searches for your workflow by name
2. Pulls workflow definition and error logs
3. Analyzes what went wrong (API errors, data issues, etc.)
4. Edits the workflow JSON to fix the issue
5. Validates the fix and pushes it back to n8n

### How to Use with AI

**Option 1: Claude Code (Recommended)**
```bash
# In this repo directory
claude code
# Then: "My Todoist workflow is broken, please fix it"
```

**Option 2: Any AI Assistant**
1. Clone this repo
2. Run setup: `./setup.sh`
3. Point your AI assistant (Claude, Cursor, etc.) to this directory
4. Share [INSTRUCTIONS.md](INSTRUCTIONS.md) with the agent
5. Say: *"My [workflow name] is failing, please debug and fix it"*

The AI will handle everything autonomously.

---

## Quick Setup (For First Time)

**One-line setup**:

```bash
./setup.sh
```

Then edit `.env` with your credentials:

```bash
# .env
N8N_BASE_URL=https://n8n.yourcompany.com
N8N_API_KEY=your-api-key-here
N8N_PROJECT_ID=your-project-id  # optional
```

Test it works:

```bash
./n8n list
```

<details>
<summary>Alternative: JSON config (click to expand)</summary>

You can also use `.n8n-config.json` instead of `.env`:

```bash
cp .n8n-config.json.example .n8n-config.json
```

Then edit the JSON file with your credentials. The tool will use `.env` if present, otherwise falls back to `.n8n-config.json`.

</details>

## What's Included

Essential files (always needed):

- **`n8n`** - Main CLI tool
- **`setup.sh`** - One-command setup
- **`.env.example`** - Environment variables template (recommended)
- **`.n8n-config.json.example`** - JSON config template (alternative)
- **`.gitignore`** - Keeps credentials safe

Helper scripts:

- **`extract-node-data.js`** - Analyze execution node outputs
- **`diff-workflow.sh`** - Compare local vs remote workflows

Documentation:

- **`README.md`** - This file
- **`INSTRUCTIONS.md`** - Agent guide for AI debugging workflows

The `workflows/` and `executions/` folders are created automatically when you use the tool.

## Requirements

- Node.js (built-in modules only, no npm install needed)
- n8n API key with appropriate permissions

## Usage

### Discovery & Search

```bash
# List all workflows
./n8n list

# Search workflows by name
./n8n search "Todoist"
```

### Debugging

```bash
# Show recent errors for a workflow
./n8n errors mp3KdoJFgCDT5ktt

# Compare successful vs failed executions
./n8n compare-executions mp3KdoJFgCDT5ktt 437776 440301
```

### Pull Workflows

```bash
# Pull all workflows
./n8n pull all

# Pull specific workflow
./n8n pull mp3KdoJFgCDT5ktt
```

### Pull Executions (with artifacts/node outputs)

```bash
# Pull last 10 executions
./n8n pull-executions mp3KdoJFgCDT5ktt

# Pull last 20 executions
./n8n pull-executions mp3KdoJFgCDT5ktt 20
```

### Push Workflow Changes

```bash
# Validate before pushing
./n8n validate workflows/mp3KdoJFgCDT5ktt_Workflow_Name.json

# Push changes
./n8n push workflows/mp3KdoJFgCDT5ktt_Workflow_Name.json
```

**Note:** Only core workflow fields can be updated via push:

- `name` - Workflow name
- `nodes` - Workflow nodes and their configuration
- `connections` - Node connections
- `settings` - Workflow settings
- `staticData` - Static workflow data

Read-only fields (like `active`, `tags`, timestamps) are automatically filtered out and must be changed in the n8n UI.

## Directory Structure

```
n8n-scripts/
├── n8n                     # CLI executable
├── .n8n-config.json        # API credentials (gitignored)
├── workflows/              # Pulled workflow JSON files
│   └── <id>_<name>.json
└── executions/             # Execution data with node outputs
    └── <workflow-id>/
        └── <execution-id>_<mode>_<status>.json
```

## Workflow Development

1. **Pull workflow**: `./n8n pull <workflow-id>`
2. **Edit locally**: Modify the JSON in `workflows/` directory
3. **Validate**: `./n8n validate workflows/<file>.json`
4. **Push changes**: `./n8n push workflows/<file>.json`
5. **Debug with executions**: `./n8n pull-executions <workflow-id>` to see actual node outputs

## For Developers

Manual workflow debugging commands are available for hands-on troubleshooting:

```bash
./n8n search "My Workflow"     # Find the workflow
./n8n errors <workflow-id>      # See what's failing
./n8n pull <workflow-id>        # Get the workflow
# ... edit the JSON ...
./n8n validate <file>           # Check it's valid
./n8n push <file>              # Deploy the fix
```

See sections below for detailed usage.

## Analyzing Execution Data

Use the helper script to inspect node outputs from executions:

```bash
# List all nodes in an execution
./extract-node-data.js executions/<workflow-id>/<execution-id>.json

# Extract specific node output
./extract-node-data.js executions/<workflow-id>/<execution-id>.json "Node Name"
```

Example:

```bash
./extract-node-data.js executions/mp3KdoJFgCDT5ktt/437776_manual_success.json
./extract-node-data.js executions/mp3KdoJFgCDT5ktt/437776_manual_success.json "Get many rows Katalog"
```

## Tips

- Execution files contain full node data including inputs/outputs
- Use executions for debugging - see exactly what each node produced
- Workflow files can be version controlled (but exclude `.n8n-config.json`)
- Use `extract-node-data.js` to quickly inspect what data flows through each node
