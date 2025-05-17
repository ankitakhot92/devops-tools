#!/bin/bash
#
# -----------------------
#Description: This script monitors service health and restart it if it is inactive
#Author: Ankita Khot
#Date Created: 14th May 2025
#Date Modified: 14th May 2025
#Usage: sudo ./system_health_mon_restart.sh
#Notes:
#  - The script must be executed as root.
#  - The script execution can be scheduled using cron for automatic monitor and restart of services
# -------------------------
#
#
SERVICE="nginx"
DATE=$(date "+%Y-%m-%d %H-%M-%S")
LOG_FILE="/var/log/monitor_service_script.log"

SERVICE_STATUS=$(systemctl is-active $SERVICE)

if systemctl is-active --quiet $SERVICE
then
	echo "[$DATE] $SERVICE is running" | tee -a $LOG_FILE
else
	echo "[$DATE] $SERVICE is not running. Attempting restart..." | tee -a $LOG_FILE
	systemctl restart $SERVICE

	# Check again after restart
	if systemctl is-active --quiet $SERVICE
	then
		echo "$SERVICE restarted successfully." | tee -a $LOG_FILE
	else
		echo "Failed to restart $SERVICE!" | tee -a $LOG_FILE
	fi
fi
