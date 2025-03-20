# Quick Start Guide

This is a Docker environment for exploring the NixOS Hyprland configuration from [XNM1's repository](https://github.com/XNM1/linux-nixos-hyprland-config-dotfiles).

## One-line Installation

Run this command to download and run the installation script:

```bash
curl -sSL https://raw.githubusercontent.com/YOUR_USERNAME/nixos-hyprland-docker/main/install.sh | bash
```

Replace `YOUR_USERNAME` with your GitHub username where you've pushed this repository.

## Interactive Menu

For an interactive experience, run:

```bash
./nixos-docker.sh
```

This will present a menu with all available options.

## Manual Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/YOUR_USERNAME/nixos-hyprland-docker.git
   cd nixos-hyprland-docker
   ```

2. Run the installation script:
   ```bash
   chmod +x install.sh
   ./install.sh
   ```

## Note

This Docker setup provides a way to explore and modify the NixOS configuration files but does not run Hyprland itself, as Wayland compositors require direct GPU access, which is not suitable for Docker containers.

For full installation on a real machine, please refer to the original repository's README. 