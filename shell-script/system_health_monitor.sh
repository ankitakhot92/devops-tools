#!/bin/bash
#
# -----------------
# Description: System Health Monitor Script
# Author: Ankita Khot
# Date Created: 14th May 2025
# Date Modified: 14th May 2025
#
# Usage: sudo ./system_health_monitor.sh
# Notes:
#   - Install SMTP to be able to send report via email
#   - Send the report via email every four hours using a crontab entry for root user: 0 */4 * * * ./system_health_monitor.sh <youremail@gmail.com>
# -----------------
#
#

LOG_FILE="/var/log/sys_health.log"
TIMESTAMP=$(date "+%Y-%m-%d_%H-%M-%S")
HOSTNAME=$(hostname)

# Check if running as root wherever necessary
require_root() {
	if [ $EUID -ne 0 ]
	then
		echo "This option requires sudo priviledges."
		exit 1
	fi
}

# Disk Usage check
disk_usage() {
	require_root
	echo -e "\n[DISK USAGE - $TIMESTAMP]" | tee -a $LOG_FILE
	df -h | tee -a $LOG_FILE
}

# Memory Usage
memory_usage() {
	require_root
	echo -e "\n[MEMORY USAGE - $TIMESTAMP]" | tee -a $LOG_FILE
	free -h
}

# CPU Performance
cpu_status() {
	require_root
	echo -e "\n[CPU LOAD - $TIMESTAMP]" | tee -a $LOG_FILE
	uptime | tee -a $LOG_FILe
	top -b -n1 | head -10 | tee -a $LOG_FILE
}

# Running Services
check_services() {
	require_root
	echo -e "\n[Running Services - $TIMESTAMP]" | tee -a $LOG_FILE
	systemctl list-units --type=service --state=running | head -20 | tee -a $LOG_FILE
}

# Generate full report
generate_report() {
	require_root
	REPORT="/tmp/sys_report_$TIMESTAMP.txt"
	echo "System Health Report - $HOSTNAME - $TIMESTAMP" | tee -a $LOG_FILE
	{
	echo -e "\n== Disk Usage =="
	df -h
	echo -e "\n== Memory Usage =="
	free -h
	echo -e "\n== CPU Load =="
	uptime
	top -b -n1 | head -10
	echo -e "\n== Running Services =="
	systemctl list-units --type=service --state=running | head -20
	} >> $REPORT

	cat $REPORT >> $LOG_FILE
	echo "Report generated: $REPORT"
}

# Read Email
read_email() {
        read -p "Enter your email address: " EMAIL_RECEIPIENT
	send_email
}

# Send Email
send_email() {
	generate_report
	SUBJECT="System Health Report - $HOSTNAME - $TIMESTAMP"
	cat "$REPORT" | mail -s "$SUBJECT" "$EMAIL_RECEIPIENT"
	#mail -s "$SUBJECT" "$EMAIL_RECEIPIENT" < "$REPORT"
	echo "Email sent to $EMAIL_RECEIPIENT"
}

# Menu
menu() {
	while true
	do
		echo -e "\n==== System Health Menu ===="
	        echo "1. View Disk Usage"
		echo "2. View Memory USage"
		echo "3. View CPU Load"
		echo "4. View Running Services"
		echo "5. Generate Full Health Report"
		echo "6. Send Health Report via Email"
		echo "7. Exit"
		read -rp "Enter your choice: " choice

		case $choice in 
			1) disk_usage ;;
			2) memory_usage ;;
			3) cpu_status ;;
			4) check_services ;;
			5) generate_report ;;
			6) read_email ;;
			7) echo "Exiting..."; exit 0 ;;
			*) echo "Invalid choice. Try again." ;;
		esac
	done
}

# main
if [ -z "$1" ]
then
        # for menu driven options
  	menu
else
        # for cron
	EMAIL_RECEIPIENT=$1
	send_email
fi
