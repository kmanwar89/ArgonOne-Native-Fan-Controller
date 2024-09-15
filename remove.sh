#! /bin/bash

# Simple script to undo changes
# Author: Kadar Anwar
# Date: 15 SEP 2024

# Disable i2c
sudo raspi-config nonint do_i2c 1
echo "i2c disabled"

# Delete the configuration file
sudo rm /etc/argon_fan_controller_cfg.yml
echo "Configuration file deleted from /etc"

# Remove the main executable
sudo rm /usr/bin/argon_fan_controller
echo "Binary deleted from /usr/bin"

# Stop, disable, mask & remove the service files
sudo systemctl stop argon_fan_controller.service
sudo systemctl disable argon_fan_controller.service
sudo rm /lib/systemd/system/argon_fan_controller.service
echo "Systemctl services stopped, disabled & deleted"

# Prompt for an (optional) reboot
echo "All files have been removed; optionally reboot the Pi 4 to ensure no \
cache or temporary files have been left behind"
