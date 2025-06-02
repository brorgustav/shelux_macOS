#!/usr/bin/env bash
# install_terminals.sh
# Installs alternative terminal emulators via Homebrew:
# iTerm2 (cask), Alacritty, Kitty, and WezTerm.

set -euo pipefail

echo "Installing iTerm2..."
brew install --cask iterm2

echo
echo "Installing Alacritty, Kitty, and WezTerm..."
brew install alacritty kitty wezterm

echo
echo "✅  Done. You can launch:"
echo "  - iTerm2 (Applications → iTerm.app)"
echo "  - Alacritty"
echo "  - Kitty"
echo "  - WezTerm"
