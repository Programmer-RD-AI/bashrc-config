# My `.bashrc`

This repository contains my customized `.bashrc` file for an enhanced terminal experience. It's packed with useful aliases, environment variables, and tool integrations to make my shell efficient and user-friendly.

## Features

- **Custom PATH** for easy access to local binaries
- **Environment Variables** with `.env` file support for global and project-specific configurations
- **Aliases** for safer and faster commands (`ls`, `rm`, `grep`, etc.)
- **Git-Aware Prompt** with branch and status indicators
- **Tool Support** for `conda`, `nvm`, and more
- **History Tweaks** for smarter and bigger history management
- **Special Functions** for extracting archives and managing environment variables

## Environment Variables

The `.bashrc` includes built-in support for `.env` files:

- **Global Variables**: Create `~/.env` for system-wide environment variables
- **Project Variables**: Place `.env` in project directories for project-specific variables
- **Auto-loading**: Variables are automatically loaded on shell startup
- **Manual Loading**: Use `load_env [path]` to load specific `.env` files

Example `.env` file:

```bash
# API Keys
OPENAI_API_KEY=your_key_here
GITHUB_TOKEN=your_token_here

# Application Settings
NODE_ENV=development
DEBUG_MODE=false
```

## Installation

Clone and set up the configuration:

```bash
git clone https://github.com/Programmer-RD-AI/.bashrc.git
cp .bashrc/.bashrc ~/.config/bash/
source ~/.config/bash/bashrc
```

## Security

- Add .env to your global .gitignore
- Set appropriate permissions: chmod 600 ~/.env
- Never commit .env files to version control

## Contributing

Feel free to submit issues and pull requests for improvements or bug fixes.
