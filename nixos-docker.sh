#!/bin/bash
set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Print colored message
print_message() {
  local color=$1
  local message=$2
  echo -e "${color}${message}${NC}"
}

# Check if a command exists
command_exists() {
  command -v "$1" &> /dev/null
}

# Check for NVIDIA GPUs
check_nvidia_status() {
  print_message "$YELLOW" "Checking NVIDIA GPU status..."
  
  if command -v nvidia-smi &> /dev/null; then
    if nvidia-smi &> /dev/null; then
      print_message "$GREEN" "NVIDIA GPU detected and operational."
      
      # Check if container is running and nvidia-container-toolkit is working
      if docker ps -q --filter "name=nixos-hyprland" &> /dev/null; then
        if docker exec nixos-hyprland nvidia-smi &> /dev/null; then
          print_message "$GREEN" "Container has access to NVIDIA GPU."
        else
          print_message "$RED" "Container doesn't have access to NVIDIA GPU."
          print_message "$YELLOW" "Verify NVIDIA Container Toolkit is properly installed."
        fi
      else
        print_message "$YELLOW" "Container is not running. Cannot verify GPU access."
      fi
    else
      print_message "$RED" "NVIDIA GPU detected but not operational. Check drivers."
    fi
  else
    print_message "$YELLOW" "No NVIDIA GPU detected or drivers not installed."
  fi
  
  read -p "Press enter to continue..."
}

# Main menu
show_menu() {
  clear
  print_message "$BLUE" "============================================================"
  print_message "$BLUE" "            NixOS Hyprland Docker Environment               "
  print_message "$BLUE" "============================================================"
  print_message "$GREEN" "1) Setup - Install dependencies and build container"
  print_message "$GREEN" "2) Start - Start the container"
  print_message "$GREEN" "3) Shell - Access container shell"
  print_message "$GREEN" "4) Stop - Stop the container"
  print_message "$GREEN" "5) Export - Export configuration files"
  print_message "$GREEN" "6) Rebuild - Rebuild the container after changes"
  print_message "$GREEN" "7) Status - Check container status"
  print_message "$GREEN" "8) View logs"
  print_message "$GREEN" "9) Check NVIDIA GPU status"
  print_message "$RED" "0) Exit"
  print_message "$BLUE" "============================================================"
  echo -n "Enter your choice [0-9]: "
}

# Setup function
setup() {
  print_message "$YELLOW" "Running setup..."
  ./install.sh
  print_message "$GREEN" "Setup complete!"
  read -p "Press enter to continue..."
}

# Start container
start_container() {
  print_message "$YELLOW" "Starting container..."
  docker-compose up -d
  print_message "$GREEN" "Container started!"
  read -p "Press enter to continue..."
}

# Access shell
access_shell() {
  print_message "$YELLOW" "Accessing container shell..."
  print_message "$YELLOW" "Type 'exit' to return to this menu."
  docker-compose exec nixos-hyprland fish || {
    print_message "$RED" "Failed to access container. Is it running?"
    read -p "Press enter to continue..."
    return
  }
}

# Stop container
stop_container() {
  print_message "$YELLOW" "Stopping container..."
  docker-compose down
  print_message "$GREEN" "Container stopped!"
  read -p "Press enter to continue..."
}

# Export config
export_config() {
  print_message "$YELLOW" "Exporting configuration..."
  ./export-config.sh
  print_message "$GREEN" "Configuration exported to ./exported_config!"
  read -p "Press enter to continue..."
}

# Rebuild container
rebuild_container() {
  print_message "$YELLOW" "Rebuilding container..."
  docker-compose build
  print_message "$GREEN" "Container rebuilt!"
  read -p "Press enter to continue..."
}

# Check status
check_status() {
  print_message "$YELLOW" "Container status:"
  docker-compose ps
  read -p "Press enter to continue..."
}

# View logs
view_logs() {
  print_message "$YELLOW" "Container logs (press Ctrl+C to exit):"
  docker-compose logs -f
}

# Check dependencies
check_deps() {
  if ! command_exists docker || ! command_exists docker-compose; then
    print_message "$RED" "Docker or Docker Compose not found."
    print_message "$YELLOW" "Please run option 1 (Setup) first."
    read -p "Press enter to continue..."
    return 1
  fi
  return 0
}

# Main loop
while true; do
  show_menu
  read -r choice
  
  case $choice in
    1) setup ;;
    2) 
      if check_deps; then
        start_container
      fi
      ;;
    3) 
      if check_deps; then
        access_shell
      fi
      ;;
    4) 
      if check_deps; then
        stop_container
      fi
      ;;
    5) 
      if check_deps; then
        export_config
      fi
      ;;
    6) 
      if check_deps; then
        rebuild_container
      fi
      ;;
    7) 
      if check_deps; then
        check_status
      fi
      ;;
    8) 
      if check_deps; then
        view_logs
      fi
      ;;
    9)
      check_nvidia_status
      ;;
    0) 
      print_message "$GREEN" "Goodbye!"
      exit 0
      ;;
    *) 
      print_message "$RED" "Invalid option. Please try again."
      read -p "Press enter to continue..."
      ;;
  esac
done 