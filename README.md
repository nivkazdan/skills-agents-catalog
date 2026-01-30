# Skills & Agents Catalog

A comprehensive, categorized catalog of AI skills, agents, plugins, and tools for Claude Code and AI-assisted development.

## Overview

This repository consolidates **1,400+ items** from 8 source repositories into 11 use-case categories:

| Category | Description |
|----------|-------------|
| 🔬 **research** | Research assistants, analysts, search specialists |
| 💰 **investments** | Financial tools, crypto, trading, portfolio management |
| 📊 **competitor-analysis** | Market research, benchmarking, competitive intelligence |
| 📣 **marketing** | Marketing automation, SEO, brand strategy, campaigns |
| ✍️ **content** | Documentation, technical writing, content creation |
| 💻 **development** | Full-stack development, language specialists, APIs |
| 🤖 **automation** | Workflow orchestration, CI/CD, deployment, bots |
| 📈 **data-analysis** | ML/AI, data pipelines, analytics, visualization |
| 🔒 **security** | Security auditing, compliance, vulnerability scanning |
| 👥 **collaboration** | Team tools, project management, code review |
| 📚 **education** | Tutorials, guides, learning resources |

## Source Repositories

| Repository | Content | Count |
|------------|---------|-------|
| [awesome-claude-code-subagents](https://github.com/nivkazdan/awesome-claude-code-subagents) | Specialized Claude Code subagents | 128 agents |
| [claude-code-plugins-plus-skills](https://github.com/nivkazdan/claude-code-plugins-plus-skills) | Plugins with embedded AI skills | 323 plugins, 520 skills |
| [claude-flow](https://github.com/nivkazdan/claude-flow) | Agent orchestration platform | 367 agents, 134 skills |
| [superpowers](https://github.com/nivkazdan/superpowers) | Agentic skills framework | 14 skills |
| [dev-browser](https://github.com/nivkazdan/dev-browser) | Browser automation skill | 1 skill |
| [claude-code-heavy](https://github.com/nivkazdan/claude-code-heavy) | Multi-agent research orchestration | 1 tool |
| [Skill_Seekers](https://github.com/nivkazdan/Skill_Seekers) | Skill creation tool | 1 tool |
| [awesome-claude-skills](https://github.com/nivkazdan/awesome-claude-skills) | Curated skill references | Reference |

## Directory Structure

```
catalog/
├── research/
│   ├── agents/       # Research-focused agents
│   ├── skills/       # Research skills
│   ├── plugins/      # Research plugins
│   └── tools/        # Research tools
├── investments/
├── competitor-analysis/
├── marketing/
├── content/
├── development/
├── automation/
├── data-analysis/
├── security/
├── collaboration/
└── education/
```

## Multi-Category Organization

Items are organized by **use-case**, not source. A single item can appear in multiple categories based on its functionality:

- A `penetration-tester` agent appears in both `security` and `development`
- A `crypto-portfolio-tracker` plugin appears in both `investments` and `data-analysis`
- A `technical-writer` agent appears in both `content` and `development`

## Quick Start

### Browse Online
Navigate to the category folders above to explore available items.

### Clone Locally
```bash
git clone https://github.com/nivkazdan/skills-agents-catalog.git
cd skills-agents-catalog
```

### Run Extraction (Update from Sources)
```bash
./scripts/extract-and-organize.sh
```

## Auto-Sync

This repository automatically syncs from source repositories **weekly** via GitHub Actions.
Updates are committed directly to the main branch.

## Using Items

### Agents
Copy agent definitions to your `.claude/agents/` directory or reference them in your prompts.

### Skills
Install skills to your Claude Code configuration using the skill's instructions.

### Plugins
Follow each plugin's README for installation instructions.

### Tools
Each tool has its own setup requirements documented in its directory.

## Category Indexes

Each category has a `README.md` with:
- Complete list of all agents in that category
- Complete list of all skills in that category
- Complete list of all plugins in that category
- Complete list of all tools in that category

## Contributing

This is an aggregation repository. To contribute:
1. Submit changes to the appropriate source repository
2. Changes will sync automatically within a week

## Verification

See [VERIFICATION.md](VERIFICATION.md) for extraction verification details.

## License

Content is sourced from multiple repositories with their respective licenses.
See individual items for specific licensing.

---

*Maintained by [@nivkazdan](https://github.com/nivkazdan)*
*Auto-synced weekly from source repositories*
