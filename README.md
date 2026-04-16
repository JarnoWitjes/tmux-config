# Tmux Config

Personal tmux configuration with [Catppuccin Macchiato](https://github.com/catppuccin/tmux) theme, nerd font icons, and macOS notifications.

## Prerequisites

- [tmux](https://github.com/tmux/tmux) (3.4+)
- [Homebrew](https://brew.sh)
- A [Nerd Font](https://www.nerdfonts.com/) in your terminal (e.g., Hack Nerd Font)

## Installation

```bash
git clone https://github.com/JarnoWitjes/tmux-config.git
cd tmux-config
./setup.sh
```

The setup script handles everything automatically:

1. Installs `yq` via Homebrew (dependency for window name icons)
2. Installs [TPM](https://github.com/tmux-plugins/tpm) (Tmux Plugin Manager)
3. Symlinks `tmux.conf` to `~/.tmux.conf` (backs up any existing config)
4. Installs all plugins

After setup, start a new tmux session:

```bash
tmux new -s my-project
```

## Key Bindings

This config changes the prefix key from the default `Ctrl-b` to `Ctrl-Space`.
All tmux commands start with pressing this prefix first, unless noted otherwise.

| Action | Keys | Notes |
|--------|------|-------|
| Prefix | `Ctrl-Space` | Hold Ctrl, tap Space |
| Previous window | `Alt-H` | No prefix needed |
| Next window | `Alt-L` | No prefix needed |
| Split pane vertically | `prefix` then `"` | Opens in current directory |
| Split pane horizontally | `prefix` then `%` | Opens in current directory |
| Install plugins | `prefix` then `I` | After adding a new plugin |
| Update plugins | `prefix` then `U` | Updates all plugins |

> **Tip:** Vim users will recognise `H`/`L` for left/right navigation.

## Features

### Catppuccin Macchiato Theme

The status bar uses the [Catppuccin Macchiato](https://github.com/catppuccin/catppuccin) colour palette with rounded window tabs. If your terminal also uses Catppuccin Macchiato (recommended), the colours will blend seamlessly.

### Smart Window Names

Each tab automatically shows the running program with a nerd font icon.
For example: ` lazygit`, ` node`, ` zsh`. This requires a nerd font in your terminal — without one you'll see placeholder characters instead of icons.

### Terminal Window Title

The terminal title bar shows the current session and window name in the format `Session - Program` (e.g., `my-project - lazygit`). This makes it easy to identify tmux sessions when using `Cmd-Tab` or multiple terminal windows.

### macOS Notifications

When a program sends a terminal bell (e.g., Claude Code requesting input), you'll receive a macOS notification with sound. This only triggers on actual program bells, not on regular window activity.

## Status Bar Layout

```
┌──────────────────────────────────────────────────────────────┐
│ session  ╭ 1 zsh ╮╭ 2 lazygit ╮╭ 3 node ╮    ~/project 12:30 │
└──────────────────────────────────────────────────────────────┘
  left ↑         window tabs ↑                 right ↑
```

- **Left:** Session name
- **Center:** Window tabs with program name and nerd font icon
- **Right:** Current directory and time

## Plugins

| Plugin | What it does |
|--------|-------------|
| [TPM](https://github.com/tmux-plugins/tpm) | Manages plugin installation and updates |
| [tmux-sensible](https://github.com/tmux-plugins/tmux-sensible) | Sensible default settings that everyone agrees on |
| [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator) | Move between vim splits and tmux panes with `Ctrl-h/j/k/l` |
| [tmux-nerd-font-window-name](https://github.com/joshmedeski/tmux-nerd-font-window-name) | Adds nerd font icons to window names based on running program |
| [Catppuccin](https://github.com/catppuccin/tmux) | Catppuccin Macchiato theme for status bar and windows |

## Tip: Oh My Zsh tmux plugin

If you use [Oh My Zsh](https://ohmyz.sh/), enable the `tmux` plugin for handy aliases:

```bash
# In ~/.zshrc, add tmux to your plugins:
plugins=(... tmux)
```

This gives you shortcuts like:

| Alias | Command | What it does |
|-------|---------|-------------|
| `ts` | `tmux new-session -s` | Start a new named session, e.g. `ts MyProject` |
| `ta` | `tmux attach -t` | Attach to an existing session, e.g. `ta MyProject` |
| `tl` | `tmux list-sessions` | List all running sessions |
| `tkss` | `tmux kill-session -t` | Kill a specific session |

> **Tip:** Use `ts` to start a session per project. The session name shows up in the status bar and terminal title.

## Customisation

The config lives in `tmux.conf`. After making changes, reload with:

```bash
tmux source-file ~/.tmux.conf
```

Or restart tmux entirely:

```bash
tmux kill-server && tmux
```

### Changing the theme flavour

Replace `macchiato` with `latte`, `frappe`, or `mocha` on this line:

```tmux
set -g @catppuccin_flavor "macchiato"
```

### Why is Catppuccin loaded manually?

You'll notice Catppuccin is loaded with `run '~/.tmux/plugins/tmux/catppuccin.tmux'` instead of being listed as a TPM plugin. This is intentional: the status bar configuration references Catppuccin's `@catppuccin_status_*` variables, which need to exist before they're used. TPM loads plugins at the very end of the config, which would be too late. Catppuccin is still managed by TPM for updates (`prefix + U`).
