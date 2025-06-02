#!/usr/bin/env bash
# setup_gnu_coreutils.sh
# Installs coreutils, findutils, gnu-sed, gawk, grep via Homebrew,
# then updates ~/.bash_profile and ~/.zshrc to prefer GNU tools. 
# Uses only BSD‐compatible flags (no `-P`).

set -euo pipefail

echo "Installing GNU coreutils, findutils, gnu-sed, gawk, grep via Homebrew..."
brew install coreutils findutils gnu-sed gawk grep

# Compute paths to prepend
COREUTILS_PATH="$(brew --prefix coreutils)/libexec/gnubin"
FINDUTILS_PATH="$(brew --prefix findutils)/libexec/gnubin"
GSED_PATH="$(brew --prefix gnu-sed)/libexec/gnubin"
GAWK_PATH="$(brew --prefix gawk)/libexec/gnubin"
GGREP_PATH="$(brew --prefix grep)/libexec/gnubin"

# Helper: prepend a line to a file only if not already present
prepend_if_missing() {
  local line="$1"
  local file="$2"
  mkdir -p "$(dirname "$file")"
  touch "$file"
  # -F = fixed string, -x = exact match of whole line, -q = quiet
  if ! grep -Fxq "$line" "$file"; then
    printf "%s\n" "$line" | cat - "$file" > "$file.tmp"
    mv "$file.tmp" "$file"
    echo "  → Added to $file: $line"
  else
    echo "  → Already in $file: $line"
  fi
}

# Update ~/.bash_profile
BASH_PROFILE="$HOME/.bash_profile"
echo
echo "Updating $BASH_PROFILE to prioritize GNU tools..."
prepend_if_missing "export PATH=\"$COREUTILS_PATH:\$PATH\"" "$BASH_PROFILE"
prepend_if_missing "export PATH=\"$FINDUTILS_PATH:\$PATH\"" "$BASH_PROFILE"
prepend_if_missing "export PATH=\"$GSED_PATH:\$PATH\""    "$BASH_PROFILE"
prepend_if_missing "export PATH=\"$GAWK_PATH:\$PATH\""    "$BASH_PROFILE"
prepend_if_missing "export PATH=\"$GGREP_PATH:\$PATH\""   "$BASH_PROFILE"

# Update ~/.zshrc
ZSHRC="$HOME/.zshrc"
echo
echo "Updating $ZSHRC to prioritize GNU tools..."
prepend_if_missing "export PATH=\"$COREUTILS_PATH:\$PATH\"" "$ZSHRC"
prepend_if_missing "export PATH=\"$FINDUTILS_PATH:\$PATH\"" "$ZSHRC"
prepend_if_missing "export PATH=\"$GSED_PATH:\$PATH\""    "$ZSHRC"
prepend_if_missing "export PATH=\"$GAWK_PATH:\$PATH\""    "$ZSHRC"
prepend_if_missing "export PATH=\"$GGREP_PATH:\$PATH\""   "$ZSHRC"

echo
echo "✅  GNU coreutils, findutils, gnu-sed, gawk, and grep installed."
echo "    Restart your shell or run 'source ~/.bash_profile' (or 'source ~/.zshrc')."
