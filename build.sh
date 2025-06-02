#!/usr/bin/env bash
# build.sh
# Make every .sh under build/ executable (so you only need to maintain the scripts themselves)
#!/usr/bin/env bash
set -euo pipefail

# === Install Homebrew if missing ===
if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew not found. Installing Homebrew…"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  # After install, configure shell environment for Homebrew
  if [[ -d "/opt/homebrew/bin" ]]; then
    # Apple Silicon
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -d "/usr/local/bin" ]]; then
    # Intel
    echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.bash_profile
    eval "$(/usr/local/bin/brew shellenv)"
  fi

  echo "Homebrew installation complete."
else
  echo "Homebrew already installed at $(command -v brew)."
fi

# === Install dialog via Homebrew ===
if ! command -v dialog >/dev/null 2>&1; then
  echo "Installing dialog..."
  brew install dialog
  echo "dialog installation complete."
else
  echo "dialog is already installed at $(command -v dialog)."
fi



DIR_NAME="build"

# 1) Ensure the build directory exists
if [[ ! -d "$DIR_NAME" ]]; then
  echo "Error: Directory '$DIR_NAME' not found."
  echo "Please create '$DIR_NAME' and put your helper scripts inside it."
  exit 1
fi

# 2) Make all .sh files in build/ executable
echo "Marking all scripts in '$DIR_NAME/' as executable..."
find "$DIR_NAME" -type f -name '*.sh' -print0 | xargs -0 chmod +x

echo "✅  Done. All .sh files in '$DIR_NAME/' are now executable."
echo "You can now run './run_me.sh' to launch the menu."