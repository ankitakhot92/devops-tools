#!/bin/bash
#
#Description: Performs system package update and upgrade
#Author: Ankita Khot
#Date Created: 14th May 2025
#Date Modified: 14th May 2025
#
#Usage: sudo ./system_package_update.sh
#Notes:
#  - Make sure to provide executable permissions to the script.
#  - This script can be schedule to execute using cron for automatic package updates/upgrade
#  - For centos/redhat/fedora use yum or dnf inplace of apt
#

# Exit on error
set -e

LOG_FILE=/var/log/system_package_upgrade.log
DATE=$(date "+%Y-%m-%d %H-%M-%S")

# Ensure script is run as root
if [ $EUID -ne 0 ]
then
	echo "[$(date)] Please run as root or use sudo." | tee -a $LOG_FILE
	exit 1
fi

echo "[$(date)] Starting system update and upgrade..." | tee -a $LOG_FILE

# Update the package list
apt update | tee -a $LOG_FILE

# Upgrade all upgradable packages
apt upgrade -y | tee -a $LOG_FILE

# Remove unnecessary Packages
apt autoremove -y | tee -a $LOG_FILE

# Logging finish
echo "[$(date)] System update and upgrade completed." | tee -a $LOG_FILE
