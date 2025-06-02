#!/usr/bin/env bash
# tweak_prompt_bash.sh
# Adds a Linux‐style prompt to ~/.bash_profile showing user@host:cwd$ plus Git branch.
# Uses only BSD‐compatible syntax.

set -euo pipefail

BASH_PROFILE="$HOME/.bash_profile"

# Ensure ~/.bash_profile exists
if [[ ! -f "$BASH_PROFILE" ]]; then
  touch "$BASH_PROFILE"
  echo "Created $BASH_PROFILE"
fi

PROMPT_SNIPPET="
# Linux‐style prompt with Git branch
# __git_ps1 is provided by bash‐completion when installed
if [ -f \"/usr/local/etc/bash_completion.d/git-completion.bash\" ]; then
  source \"/usr/local/etc/bash_completion.d/git-completion.bash\"
fi

export PS1='\\[\\e[32m\\]\\u@\\h\\[\\e[0m\\]:\\[\\e[34m\\]\\w\\[\\e[0m\\]\$(__git_ps1 \" (%s)\")\\\$ '
"

# grep -F = fixed string
if ! grep -F "__git_ps1" "$BASH_PROFILE" >/dev/null 2>&1; then
  printf "%s\n" "$PROMPT_SNIPPET" >> "$BASH_PROFILE"
  echo "Appended Linux‐style PS1 to $BASH_PROFILE"
else
  echo "PS1 snippet (with __git_ps1) already present in $BASH_PROFILE"
fi

echo
echo "✅  Done. Run 'source ~/.bash_profile' or open a new Bash shell to see the new prompt."
