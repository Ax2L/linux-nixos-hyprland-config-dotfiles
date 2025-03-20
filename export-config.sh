#!/bin/bash
set -e

echo "Exporting configuration files..."

# Create export directory if it doesn't exist and set permissions
rm -rf ./exported_config
mkdir -p ./exported_config
chmod 777 ./exported_config

# Copy the configuration from the running container
container_id=$(sudo docker-compose ps -q nixos-hyprland)
if [ -z "$container_id" ]; then
  echo "Container is not running. Starting it..."
  sudo docker-compose up -d
  container_id=$(sudo docker-compose ps -q nixos-hyprland)
fi

echo "Copying files from container..."
sudo docker cp $container_id:/etc/nixos ./exported_config/
sudo docker cp $container_id:/home/nixos ./exported_config/nixos_home

# Fix ownership and permissions 
echo "Setting correct permissions..."
sudo chown -R $USER:$USER ./exported_config
sudo chmod -R u+rw ./exported_config

echo "Configuration files have been exported to ./exported_config"
echo "  - System config is in ./exported_config/nixos"
echo "  - Home config is in ./exported_config/nixos_home"
echo ""
echo "You can use these files on your actual NixOS system." 