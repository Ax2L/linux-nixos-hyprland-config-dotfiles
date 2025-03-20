#!/bin/sh
set -e

# Check if fish is available and in PATH
if command -v /nix/var/nix/profiles/default/bin/fish >/dev/null 2>&1; then
  shell_cmd="/nix/var/nix/profiles/default/bin/fish"
elif command -v fish >/dev/null 2>&1; then
  shell_cmd="fish"
else
  shell_cmd="sh"
fi

# Display banner
echo "============================================================"
echo "NixOS Hyprland Configuration Environment"
echo "============================================================"
echo "GitHub: https://github.com/XNM1/linux-nixos-hyprland-config-dotfiles"
echo "This container provides a NixOS environment with the configuration files"
echo "Note: Hyprland requires a physical GPU and display to run properly"
echo "============================================================"

# If no command is provided, start the shell
if [ $# -eq 0 ]; then
  echo "Starting shell: $shell_cmd"
  exec $shell_cmd
else
  # Execute command passed to docker run
  exec "$@"
fi 