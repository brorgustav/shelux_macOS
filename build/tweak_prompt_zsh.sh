#!/usr/bin/env bash
# tweak_prompt_zsh.sh
# Adds a Linux‐style prompt to ~/.zshrc showing user@host:cwd% plus Git branch.
# Uses only BSD‐compatible syntax.

set -euo pipefail

ZSHRC="$HOME/.zshrc"

# Ensure ~/.zshrc exists
if [[ ! -f "$ZSHRC" ]]; then
  touch "$ZSHRC"
  echo "Created $ZSHRC"
fi

PROMPT_SNIPPET="
# Linux‐style prompt with Git branch for Zsh
autoload -U colors && colors
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats ' (%b)'

# \\u = user, \\h = host, %~ = current directory, %n = username, %m = hostname
PROMPT='%{\$fg[green]%}%n@%m%{\$reset_color%}:%{\$fg[blue]%}%~%{\$reset_color%}\${vcs_info_msg_0_}%# '
"

if ! grep -F "vcs_info" "$ZSHRC" >/dev/null 2>&1; then
  printf "%s\n" "$PROMPT_SNIPPET" >> "$ZSHRC"
  echo "Appended Linux‐style PROMPT to $ZSHRC"
else
  echo "vcs_info/PROMPT snippet already present in $ZSHRC"
fi

echo
echo "✅  Done. Run 'source ~/.zshrc' or open a new Zsh shell to see the new prompt."
