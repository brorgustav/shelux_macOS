#!/usr/bin/env bash
# switch_to_bash5.sh
# Installs Bash 5 and bash-completion@2 via Homebrew,
# adds it to /etc/shells, and uses `sudo chsh` to update your login shell.
# Because sudo reads from a real TTY, you won’t get the Vim warning.

set -euo pipefail

echo "==== 1) Install Bash 5.x and bash-completion@2 via Homebrew ===="
brew install bash bash-completion@2

# Locate the new Bash binary
BREW_BASH_PATH="$(brew --prefix bash)/bin/bash"
echo "New Bash binary path: $BREW_BASH_PATH"

echo
echo "==== 2) Ensure $BREW_BASH_PATH is listed in /etc/shells ===="
if ! grep -Fxq "$BREW_BASH_PATH" /etc/shells; then
  echo "Adding $BREW_BASH_PATH to /etc/shells (requires sudo)..."
  echo "$BREW_BASH_PATH" | sudo tee -a /etc/shells >/dev/null
  echo "  → Appended."
else
  echo "  → Already present in /etc/shells."
fi

echo
echo "==== 3) Change your login shell to Bash 5 (via sudo) ===="
CURRENT_SHELL="$(basename "$SHELL")"
NEW_SHELL="$(basename "$BREW_BASH_PATH")"

if [[ "$CURRENT_SHELL" != "$NEW_SHELL" ]]; then
  echo "Using sudo to run: chsh -s $BREW_BASH_PATH $(whoami)"
  sudo chsh -s "$BREW_BASH_PATH" "$(whoami)"
  echo "  → sudo chsh finished. New login shell is set to: $BREW_BASH_PATH"
  echo "Note: Close all Terminal windows and reopen to pick up Bash 5."
else
  echo "  → Your login shell is already $NEW_SHELL."
fi

echo
echo "==== 4) Enable bash-completion in ~/.bash_profile ===="
BASH_PROFILE="$HOME/.bash_profile"
if [[ ! -f "$BASH_PROFILE" ]]; then
  touch "$BASH_PROFILE"
  echo "  → Created $BASH_PROFILE"
fi

COMPLETION_SNIPPET='
# Load Homebrew’s bash-completion (if installed)
if [ -f "$(brew --prefix)/etc/bash_completion" ]; then
  . "$(brew --prefix)/etc/bash_completion"
fi
'
if ! grep -F "brew --prefix)/etc/bash_completion" "$BASH_PROFILE" >/dev/null 2>&1; then
  printf "%s\n" "$COMPLETION_SNIPPET" >> "$BASH_PROFILE"
  echo "  → Appended bash-completion snippet to $BASH_PROFILE"
else
  echo "  → bash-completion already set up in $BASH_PROFILE"
fi

echo
echo "✅  Done. After reopening Terminal, verify with:"
echo "    echo \$SHELL"
echo "    bash --version"
