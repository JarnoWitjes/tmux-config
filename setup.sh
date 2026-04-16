#!/usr/bin/env bash
set -euo pipefail

# Colors
BOLD='\033[1m'
DIM='\033[2m'
RESET='\033[0m'
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'

# Catppuccin Macchiato accent colors (approximated for terminal)
MAUVE='\033[38;5;183m'
LAVENDER='\033[38;5;147m'
SURFACE='\033[38;5;60m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TMUX_CONF="$SCRIPT_DIR/tmux.conf"
TARGET="$HOME/.tmux.conf"
TPM_DIR="$HOME/.tmux/plugins/tpm"

# ─────────────────────────────────────────────────────────

print_header() {
    echo ""
    echo -e "${MAUVE}      ╺┳╸┏┳┓╻ ╻╻ ╻   ┏━╸┏━┓┏┓╻┏━╸╻┏━╸${RESET}"
    echo -e "${LAVENDER}       ┃ ┃┃┃┃ ┃┏╋┛   ┃  ┃ ┃┃┗┫┣╸ ┃┃╺┓${RESET}"
    echo -e "${MAUVE}       ╹ ╹ ╹┗━┛╹ ╹   ┗━╸┗━┛╹ ╹╹  ╹┗━┛${RESET}"
    echo ""
    echo -e "  ${DIM}Catppuccin Macchiato  ·  Nerd Fonts  ·  Notifications${RESET}"
    echo -e "  ${SURFACE}──────────────────────────────────────────────────────${RESET}"
    echo ""
}

step() {
    echo -e "  ${CYAN}${BOLD}[$1/$TOTAL]${RESET} $2"
}

ok() {
    echo -e "        ${GREEN}✓${RESET} $1"
}

skip() {
    echo -e "        ${DIM}· $1${RESET}"
}

warn() {
    echo -e "        ${YELLOW}! $1${RESET}"
}

fail() {
    echo -e "        ${RED}✗ $1${RESET}"
    exit 1
}

TOTAL=5

# ─────────────────────────────────────────────────────────

print_header

# 1. Check Homebrew
step 1 "Checking prerequisites"

if ! command -v brew &>/dev/null; then
    fail "Homebrew not found — install from https://brew.sh"
fi
ok "Homebrew"

# 2. Install yq
step 2 "Installing dependencies"

if command -v yq &>/dev/null; then
    skip "yq already installed ($(yq --version 2>&1 | head -1))"
else
    brew install yq &>/dev/null
    ok "Installed yq"
fi

# 3. Install TPM
step 3 "Setting up TPM (Tmux Plugin Manager)"

if [ -d "$TPM_DIR" ]; then
    skip "TPM already installed"
else
    git clone https://github.com/tmux-plugins/tpm "$TPM_DIR" &>/dev/null
    ok "Cloned TPM to $TPM_DIR"
fi

# 4. Symlink tmux.conf
step 4 "Linking tmux.conf"

if [ -L "$TARGET" ] && [ "$(readlink "$TARGET")" = "$TMUX_CONF" ]; then
    skip "Symlink already correct"
elif [ -f "$TARGET" ]; then
    BACKUP="$TARGET.backup.$(date +%Y%m%d%H%M%S)"
    mv "$TARGET" "$BACKUP"
    warn "Existing config backed up to ${BACKUP/$HOME/~}"
    ln -s "$TMUX_CONF" "$TARGET"
    ok "Symlinked to ${TARGET/$HOME/~}"
else
    ln -s "$TMUX_CONF" "$TARGET"
    ok "Symlinked to ${TARGET/$HOME/~}"
fi

# 5. Install plugins & reload
step 5 "Installing plugins"

if [ -n "${TMUX:-}" ]; then
    "$TPM_DIR/bin/install_plugins" &>/dev/null && ok "Plugins installed" || warn "Plugin install had warnings — run prefix+I manually"
    tmux source-file "$TARGET" 2>/dev/null && ok "Config reloaded" || warn "Could not reload — restart tmux manually"
else
    "$TPM_DIR/bin/install_plugins" &>/dev/null && ok "Plugins installed" || warn "Plugin install had warnings — run prefix+I manually"
    warn "Not inside tmux — start a new tmux session to use the config"
fi

# ─────────────────────────────────────────────────────────

echo ""
echo -e "  ${SURFACE}──────────────────────────────────────────────────────${RESET}"
echo -e "  ${GREEN}${BOLD}Done!${RESET} ${DIM}Prefix is C-Space · Theme is Catppuccin Macchiato${RESET}"
echo ""
