# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal tmux configuration repository. Contains a single `tmux.conf` that is symlinked or copied to `~/.tmux.conf`.

## Setup

1. Requires [TPM](https://github.com/tmux-plugins/tpm) at `~/.tmux/plugins/tpm/`
2. Requires `yq` (>= 4) for tmux-nerd-font-window-name: `brew install yq`
3. After changing config: `tmux source-file ~/.tmux.conf` or restart tmux
4. After changing plugins: `prefix + I` to install, `prefix + U` to update

## Key Configuration Decisions

- **Prefix**: `C-Space` (instead of default `C-b`)
- **Window/pane indexing**: starts at 1
- **Vi mode**: vi keys in copy-mode buffer
- **Window switching**: `Alt-H` / `Alt-L` (vim-style)
- **Pane splits**: open in current working directory
- **Theme**: Catppuccin Macchiato (matches Kitty terminal theme)
- **Window tabs**: rounded style, show running command with nerd font icon
- **Terminal title**: `"Session - Window"` format for Kitty window title

## Plugin Loading Order

Catppuccin is loaded **manually** before status bar configuration, not via TPM. This is required because status-left/right reference Catppuccin's `@catppuccin_status_*` variables which must exist before they're used. TPM runs at the end, which would be too late.

```
1. Catppuccin options (@catppuccin_flavor, etc.)
2. run '~/.tmux/plugins/tmux/catppuccin.tmux'  ← manual load
3. status-left / status-right using #{E:@catppuccin_status_*}
4. TPM plugin declarations (without Catppuccin)
5. run '~/.tmux/plugins/tpm/tpm'  ← TPM loads remaining plugins
```

## Plugins

| Plugin | Purpose | Managed by |
|--------|---------|------------|
| `catppuccin/tmux` | Theme (Macchiato) | Manual load + TPM for updates |
| `tmux-plugins/tpm` | Plugin manager | TPM |
| `tmux-plugins/tmux-sensible` | Sensible defaults | TPM |
| `christoomey/vim-tmux-navigator` | Seamless vim/tmux pane navigation | TPM |
| `joshmedeski/tmux-nerd-font-window-name` | Nerd font icons in window names | TPM |

## Notifications

Bell-based macOS notifications via `set-hook alert-bell` with `osascript`. Programs that ring the terminal bell (like Claude Code) trigger a macOS notification with sound.
