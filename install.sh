#!/bin/bash
set -e

# Banner
echo "============================================================"
echo "NixOS Hyprland Configuration Docker Setup"
echo "============================================================"
echo "This script will set up a Docker container with NixOS"
echo "and the Hyprland configuration from XNM1's repository."
echo "============================================================"

# Check for required commands
check_command() {
  if ! command -v "$1" &> /dev/null; then
    echo "Error: $1 is required but not installed."
    return 1
  fi
  return 0
}

check_docker() {
  if ! check_command "docker"; then
    echo "Docker is not installed. Would you like to install it? (y/n)"
    read -r answer
    if [[ "$answer" =~ ^[Yy]$ ]]; then
      echo "Installing Docker..."
      # Docker installation script
      curl -fsSL https://get.docker.com -o get-docker.sh
      sudo sh get-docker.sh
      sudo usermod -aG docker "$USER"
      echo "Docker installed. Please log out and log back in, then run this script again."
      exit 0
    else
      echo "Docker is required. Exiting."
      exit 1
    fi
  fi
  
  # Check if Docker is running
  if ! docker info &> /dev/null; then
    echo "Docker is not running. Starting Docker..."
    sudo systemctl start docker || {
      echo "Failed to start Docker. Please start it manually and try again."
      exit 1
    }
  fi
}

check_docker_compose() {
  if ! check_command "docker-compose"; then
    echo "Docker Compose is not installed. Would you like to install it? (y/n)"
    read -r answer
    if [[ "$answer" =~ ^[Yy]$ ]]; then
      echo "Installing Docker Compose..."
      # Docker Compose installation
      sudo curl -L "https://github.com/docker/compose/releases/download/v2.23.3/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
      sudo chmod +x /usr/local/bin/docker-compose
      echo "Docker Compose installed."
    else
      echo "Docker Compose is required. Exiting."
      exit 1
    fi
  fi
}

# Check for Git
check_git() {
  if ! check_command "git"; then
    echo "Git is not installed. Would you like to install it? (y/n)"
    read -r answer
    if [[ "$answer" =~ ^[Yy]$ ]]; then
      echo "Installing Git..."
      if command -v apt &> /dev/null; then
        sudo apt update && sudo apt install -y git
      elif command -v dnf &> /dev/null; then
        sudo dnf install -y git
      elif command -v yum &> /dev/null; then
        sudo yum install -y git
      elif command -v pacman &> /dev/null; then
        sudo pacman -S --noconfirm git
      else
        echo "Could not determine package manager. Please install Git manually."
        exit 1
      fi
      echo "Git installed."
    else
      echo "Git is required. Exiting."
      exit 1
    fi
  fi
}

# Clone repository if not already present
clone_repo() {
  local repo_url="https://github.com/XNM1/linux-nixos-hyprland-config-dotfiles.git"
  local temp_dir="temp_nixos_repo"

  # Create temporary directory if needed
  if [ ! -d "nixos" ] || [ ! -d "home" ]; then
    echo "Cloning repository to get required files..."
    mkdir -p "$temp_dir"
    git clone "$repo_url" "$temp_dir"
    
    # Copy needed directories if they don't exist
    if [ ! -d "nixos" ]; then
      cp -r "$temp_dir/nixos" .
    fi
    
    if [ ! -d "home" ]; then
      cp -r "$temp_dir/home" .
    fi
    
    # Cleanup
    rm -rf "$temp_dir"
    echo "Repository files ready."
  else
    echo "Configuration directories already exist."
  fi
}

# Make scripts executable
make_executable() {
  chmod +x entrypoint.sh
  chmod +x export-config.sh
  chmod +x nixos-docker.sh
}

# Ensure exported_config directory has the right permissions
setup_export_dir() {
  mkdir -p exported_config
  chmod 777 exported_config
}

# Fix any potential permissions issues before building
fix_permissions() {
  # Make sure files are readable
  chmod -R +r nixos/ home/
  
  # Make sure the entrypoint is executable
  chmod +x entrypoint.sh
}

# Build and run the Docker container
build_container() {
  echo "Building Docker container..."
  docker-compose build
  
  echo "Container built successfully!"
  echo "To start the container, run: docker-compose up -d"
  echo "To access the container, run: docker-compose exec nixos-hyprland fish"
  echo "To export the configuration, run: ./export-config.sh"
}

# Main execution
check_docker
check_docker_compose
check_git
clone_repo
make_executable
setup_export_dir
fix_permissions
build_container

echo "============================================================"
echo "Setup complete!"
echo "To get started, run: docker-compose up -d"
echo "This will start the container in the background."
echo "============================================================" 