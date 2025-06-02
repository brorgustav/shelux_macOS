#!/usr/bin/env bash
# install_linux_tools.sh
# Installs a set of common Linux‐style utilities via Homebrew:
# wget, htop, tree, tmux, ncdu, jq, netcat, iproute2mac, net-tools.

set -euo pipefail

TOOLS=(
  wget
  htop
  tree
  tmux
  ncdu
  jq
  netcat
  iproute2mac
  net-tools
)

echo "Installing common Linux utilities: ${TOOLS[*]}..."
brew install "${TOOLS[@]}"

echo
echo "✅  Done. You can now use:"
echo "  - wget"
echo "  - htop"
echo "  - tree"
echo "  - tmux"
echo "  - ncdu"
echo "  - jq"
echo "  - nc  (netcat)"
echo "  - ip (via iproute2mac)"
echo "  - ifconfig / netstat / route (via net-tools)"
