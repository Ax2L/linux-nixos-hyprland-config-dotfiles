# NixOS Hyprland Docker Environment

This Docker setup provides an environment with NixOS and the Hyprland configuration from [XNM1's repository](https://github.com/XNM1/linux-nixos-hyprland-config-dotfiles).

## Important Notes

- **This Docker container provides a NixOS environment with all configuration files from the original repository.**
- **The container does not run Hyprland itself** because Wayland compositors require direct hardware access, which is not suitable for Docker containers.
- **This setup is ideal for:**
  - Exploring the NixOS configuration
  - Modifying the configuration for later use on a real NixOS system
  - Testing specific utilities included in the configuration

## Quick Start

1. Make the installation script executable:
   ```bash
   chmod +x install.sh
   ```

2. Run the installation script:
   ```bash
   ./install.sh
   ```
   
   This script will:
   - Check for and install dependencies (Docker, Docker Compose, Git)
   - Clone the repository if necessary
   - Build the Docker container
   - Set up the environment

3. Start the container:
   ```bash
   docker-compose up -d
   ```

4. Access the container:
   ```bash
   docker-compose exec nixos-hyprland fish
   ```

## Exporting the Configuration

To export the configuration for use on a real NixOS system:

1. Run the export script:
   ```bash
   chmod +x export-config.sh
   ./export-config.sh
   ```

2. The configuration files will be exported to the `./exported_config` directory.

3. Copy these files to your NixOS system:
   - `/etc/nixos` for system configuration
   - `$HOME` for user configuration

## Using on a Real NixOS System

To use this configuration on a real NixOS system:

1. Install NixOS on your computer
2. Copy the exported files to the appropriate locations
3. Follow the installation steps in the [original README](https://github.com/XNM1/linux-nixos-hyprland-config-dotfiles/blob/main/README.md)

## Container Commands

- Build the container: `docker-compose build`
- Start the container: `docker-compose up -d`
- Stop the container: `docker-compose down`
- Access the container shell: `docker-compose exec nixos-hyprland fish`
- View container logs: `docker-compose logs`

## Customization

- Edit files in the `nixos/` directory to modify system configuration
- Edit files in the `home/` directory to modify user configuration
- Rebuild the container after making changes: `docker-compose build` 