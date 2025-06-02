#!/usr/bin/env bash
# setup_oh_my_zsh.sh
# Installs Oh My Zsh, sets theme to "agnoster", and enables common plugins.
# Zsh’s built-in grep and sed are used (BSD versions).

set -euo pipefail

echo "==== 1) Install Oh My Zsh ===="
if [[ -d "$HOME/.oh-my-zsh" ]]; then
  echo "  → Oh My Zsh is already installed."
else
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

echo
echo "==== 2) Configure ~/.zshrc ===="
ZSHRC="$HOME/.zshrc"

# Ensure ~/.zshrc exists
if [[ ! -f "$ZSHRC" ]]; then
  touch "$ZSHRC"
  echo "  → Created $ZSHRC"
fi

# Change theme to agnoster (BSD sed -i '' syntax)
if grep -qE '^ZSH_THEME=' "$ZSHRC"; then
  sed -i '' 's/^ZSH_THEME=.*/ZSH_THEME="agnoster"/' "$ZSHRC"
  echo '  → Set ZSH_THEME="agnoster"'
else
  echo 'ZSH_THEME="agnoster"' >> "$ZSHRC"
  echo '  → Added ZSH_THEME="agnoster"'
fi

# Add/update plugin list
if grep -qE '^plugins=' "$ZSHRC"; then
  sed -i '' 's/^plugins=.*/plugins=(git docker zsh-autosuggestions zsh-completions)/' "$ZSHRC"
  echo '  → Updated plugins to (git docker zsh-autosuggestions zsh-completions)'
else
  echo "plugins=(git docker zsh-autosuggestions zsh-completions)" >> "$ZSHRC"
  echo '  → Added plugins=(git docker zsh-autosuggestions zsh-completions)'
fi

echo
echo "==== 3) Install zsh-autosuggestions and zsh-completions ===="
# zsh-autosuggestions
if [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]]; then
  git clone https://github.com/zsh-users/zsh-autosuggestions \
    "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
  echo "  → Installed zsh-autosuggestions"
else
  echo "  → zsh-autosuggestions already present"
fi

# zsh-completions
if [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-completions" ]]; then
  git clone https://github.com/zsh-users/zsh-completions \
    "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-completions"
  echo "  → Installed zsh-completions"
else
  echo "  → zsh-completions already present"
fi

echo
echo "✅  Done. Restart Zsh or run 'source ~/.zshrc' to apply changes."
