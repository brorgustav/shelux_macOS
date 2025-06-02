#!/usr/bin/env bash
# run_me.sh
# Dialog‐based menu with dynamic menu‐item variables to enable/disable options.

set -euo pipefail

DIR_NAME="build"   # must match your build/ folder

# === SCALE setting ===
# Increase SCALE to make dialog boxes larger, decrease to make them smaller.
SCALE=1

# === Base dimensions (before scaling) ===
BASE_MENU_HEIGHT=20
BASE_MENU_WIDTH=40

# === Compute final dimensions by applying SCALE ===
MENU_HEIGHT=$(( BASE_MENU_HEIGHT * SCALE ))
MENU_WIDTH=$(( BASE_MENU_WIDTH  * SCALE ))

BASE_DETAILS_HEIGHT=25
BASE_DETAILS_WIDTH=80
DETAILS_HEIGHT=$(( BASE_DETAILS_HEIGHT * SCALE ))
DETAILS_WIDTH=$(( BASE_DETAILS_WIDTH  * SCALE ))

# Enforce reasonable minimums (in case SCALE is set very small)
(( MENU_HEIGHT < 10 )) && MENU_HEIGHT=10
(( MENU_WIDTH  < 40 )) && MENU_WIDTH=40
(( DETAILS_HEIGHT < 10 )) && DETAILS_HEIGHT=10
(( DETAILS_WIDTH  < 40 )) && DETAILS_WIDTH=40

# === End of size‐scaling logic ===

# Ensure dialog is installed
if ! command -v dialog >/dev/null 2>&1; then
  echo "Error: 'dialog' not found. Install it with:"
  echo "    brew install dialog"
  exit 1
fi

# === MENU‐ITEM VARIABLES ===
# Set to 1 to enable, 0 to hide
ENABLE_COREUTILS=1
ENABLE_BASH5=1
ENABLE_OH_MY_ZSH=1
ENABLE_LINUX_UTILS=1
ENABLE_TERMINALS=0
ENABLE_BASH_PROMPT=1
ENABLE_ZSH_PROMPT=1

# === Helper FUNCTIONS ===

# Compose an array of enabled menu items (tag and label)
build_menu_entries() {
  local -n _tags_ref=$1
  local -n _labels_ref=$2

  _tags_ref=()
  _labels_ref=()

  local idx=1

  if [ "$ENABLE_COREUTILS" -eq 1 ]; then
    _tags_ref+=("$idx")
    _labels_ref+=("GNU coreutils")
    ((idx++))
  fi
  if [ "$ENABLE_BASH5" -eq 1 ]; then
    _tags_ref+=("$idx")
    _labels_ref+=("Bash 5.x")
    ((idx++))
  fi
  if [ "$ENABLE_OH_MY_ZSH" -eq 1 ]; then
    _tags_ref+=("$idx")
    _labels_ref+=("Oh My Zsh")
    ((idx++))
  fi
  if [ "$ENABLE_LINUX_UTILS" -eq 1 ]; then
    _tags_ref+=("$idx")
    _labels_ref+=("Linux utilities")
    ((idx++))
  fi
  if [ "$ENABLE_TERMINALS" -eq 1 ]; then
    _tags_ref+=("$idx")
    _labels_ref+=("Terminal emulators")
    ((idx++))
  fi
  if [ "$ENABLE_BASH_PROMPT" -eq 1 ]; then
    _tags_ref+=("$idx")
    _labels_ref+=("Bash prompt")
    ((idx++))
  fi
  if [ "$ENABLE_ZSH_PROMPT" -eq 1 ]; then
    _tags_ref+=("$idx")
    _labels_ref+=("Zsh prompt")
    ((idx++))
  fi
}

# Map numeric choice to script path
get_script_for_choice() {
  local choice=$1
  local idx=1

  if [ "$ENABLE_COREUTILS" -eq 1 ]; then
    if [ "$choice" -eq "$idx" ]; then
      echo "$DIR_NAME/setup_gnu_coreutils.sh"
      return
    fi
    ((idx++))
  fi
  if [ "$ENABLE_BASH5" -eq 1 ]; then
    if [ "$choice" -eq "$idx" ]; then
      echo "$DIR_NAME/switch_to_bash5.sh"
      return
    fi
    ((idx++))
  fi
  if [ "$ENABLE_OH_MY_ZSH" -eq 1 ]; then
    if [ "$choice" -eq "$idx" ]; then
      echo "$DIR_NAME/setup_oh_my_zsh.sh"
      return
    fi
    ((idx++))
  fi
  if [ "$ENABLE_LINUX_UTILS" -eq 1 ]; then
    if [ "$choice" -eq "$idx" ]; then
      echo "$DIR_NAME/install_linux_tools.sh"
      return
    fi
    ((idx++))
  fi
  if [ "$ENABLE_TERMINALS" -eq 1 ]; then
    if [ "$choice" -eq "$idx" ]; then
      echo "$DIR_NAME/install_terminals.sh"
      return
    fi
    ((idx++))
  fi
  if [ "$ENABLE_BASH_PROMPT" -eq 1 ]; then
    if [ "$choice" -eq "$idx" ]; then
      echo "$DIR_NAME/tweak_prompt_bash.sh"
      return
    fi
    ((idx++))
  fi
  if [ "$ENABLE_ZSH_PROMPT" -eq 1 ]; then
    if [ "$choice" -eq "$idx" ]; then
      echo "$DIR_NAME/tweak_prompt_zsh.sh"
      return
    fi
    ((idx++))
  fi

  # If no match or user tries to exit
  echo ""
}

# Beginner‐friendly descriptions
get_full_info() {
  case "$1" in
    1)
      cat << 'EOF'
● Uses Homebrew to install GNU coreutils, findutils, gnu-sed, gawk, and grep.

● Updates your ~/.bash_profile and ~/.zshrc so that commands like 'ls', 'grep', and
  'sed' will be their GNU versions (e.g. 'gls', 'ggrep'), matching Linux behavior.

Why? macOS ships with BSD versions of these tools, which lack some Linux features.
This step gives you full GNU functionality if you’re following Linux tutorials or scripts.
EOF
      ;;
    2)
      cat << 'EOF'
● Installs Bash 5 (and bash-completion@2) via Homebrew.

● Adds the new Bash binary to /etc/shells and changes your login shell to it.
● Updates your ~/.bash_profile so that 'bash --version' will show 5.x,
  and enables tab-completion for Git and other commands.

Why? macOS’s default is Bash 3.2. Bash 5 adds newer features (associative arrays,
new completion, improved syntax).
EOF
      ;;
    3)
      cat << 'EOF'
● Installs Oh My Zsh, a popular framework for managing Zsh settings.

● Sets your ZSH_THEME to 'agnoster' (shows Git branch, colors, etc.) and enables
  plugins: git, docker, zsh-autosuggestions, and zsh-completions.
● Clones zsh-autosuggestions and zsh-completions into ~/.oh-my-zsh/custom/plugins/.

Why? Oh My Zsh provides a powerful, friendly Zsh setup, with automatic suggestions,
Git information in your prompt, and many plugins out of the box.
EOF
      ;;
    4)
      cat << 'EOF'
● Installs common Linux-style utilities via Homebrew:
  • wget (download files from the web)
  • htop (interactive process viewer)
  • tree (display directory tree)
  • tmux (terminal multiplexer)
  • ncdu (disk usage analyzer)
  • jq (JSON processor)
  • netcat (networking utility)
  • iproute2mac (Linux 'ip' commands ported to macOS)
  • net-tools (ifconfig, netstat, route, etc.)

Why? These commands are standard on Linux; installing them lets you work exactly
as you would on a Linux box.
EOF
      ;;
    5)
      cat << 'EOF'
● Installs alternative terminal emulators via Homebrew:
  • iTerm2 (feature-rich GUI terminal)
  • Alacritty (GPU-accelerated, very fast)
  • Kitty (modern, feature-rich)
  • WezTerm (tiling, GPU-accelerated)

Why? Many Linux users prefer these terminals for split panes, better performance,
and advanced features not found in the default Terminal.app.
EOF
      ;;
    6)
      cat << 'EOF'
● Adds a Linux-style prompt to Bash by appending to ~/.bash_profile:

  user@hostname:~/current/dir $(git-branch)$

  – Username@host will appear in green. Current directory in blue.
  – Git branch (if inside a Git repo) appears in parentheses.

Why? This makes it easy to see your user, host, current path, and Git branch,
just like many Linux distributions do.
EOF
      ;;
    7)
      cat << 'EOF'
● Adds a Linux-style prompt to Zsh by appending to ~/.zshrc:

  user@hostname:~/current/dir% (branch)

  – 'user@hostname' shows in green, directory in blue, and Git branch via vcs_info
  – Makes your Zsh prompt more informative, matching Linux setups.

Why? A clear, colored prompt with Git branch info helps you navigate repositories
and servers exactly like you’d on Linux.
EOF
      ;;
    *)
      echo ""
      ;;
  esac
}

# Helper to run a script and pause
run_script() {
  local script_path="$1"
  clear
  echo ">>> Running: $script_path"
  echo "----------------------------------------"
  bash "$script_path"
  echo "----------------------------------------"
  echo ">>> Completed."
  echo
  read -rp "Press Enter to return to the menu..."
}

while true; do
  # Build arrays of enabled items
  tags=() labels=()
  build_menu_entries tags labels

  # Now “zip” them into a single array of tag/label pairs
  entries=()
  for i in "${!tags[@]}"; do
    entries+=("${tags[i]}" "${labels[i]}")
  done

  # 1) Display the main menu with only enabled items
  MENU_ITEMS_COUNT=$(( ${#entries[@]} / 2 ))
  CHOICE=$(dialog --clear \
                  --backtitle "macOS → Linux-like Environment" \
                  --title "Main Menu" \
                  --cancel-label "Exit" \
                  --menu "Use ↑/↓ to navigate, Enter to select:" \
                  "$MENU_HEIGHT" "$MENU_WIDTH" "$MENU_ITEMS_COUNT" \
                  "${entries[@]}" \
                  3>&1 1>&2 2>&3)

  # If user pressed Esc/Cancel on the main menu, exit
  if [ $? -ne 0 ]; then
    clear
    exit 0
  fi

  # 2) Show “Details & Confirmation” with scaled dimensions
  FULLINFO=$(get_full_info "$CHOICE")
  if dialog --clear \
            --backtitle "macOS → Linux-like Environment" \
            --title "Details & Confirmation" \
            --yes-label "Proceed" \
            --no-label "Back" \
            --yesno "$FULLINFO" "$DETAILS_HEIGHT" "$DETAILS_WIDTH"; then
    # Proceed → find and run corresponding script
    script_path=$(get_script_for_choice "$CHOICE")
    if [ -n "$script_path" ] && [ -x "$script_path" ]; then
      run_script "$script_path"
    else
      clear
      echo "Error: Script not found or not executable: $script_path"
      echo "Make sure you ran build.sh and that '$DIR_NAME/' exists."
      sleep 2
    fi
  else
    # Any non‐zero return (Back, Esc, Cancel) → return to main menu
    continue
  fi
done