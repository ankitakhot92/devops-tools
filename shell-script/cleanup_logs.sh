#!/bin/bash
#
#This script aims at cleaning up log files based on retention policy
#
#Author: Ankita Khot
#Date Created: 13th May 2025
#Last Modified:
#Version: 1.0
#
#Usage: ./cleanup_logs.sh
#Notes:
#  - Make sure the script has executable permissions.
#  - You can schedule it in cron for regular cleanup.
#  - Edit RETENTION and LOG_DIR variables as per your requirement.

# Retention Period in days
RETENTION=7

# Directory containing log file
LOG_DIR="/tmp/test-logs"

# Extenstion
EXTENSION="*.log"

# Logging
echo "[$(date)] Cleaning up logs in $LOG_DIR older than $RETENTION days..."

# Find and delete log files older than Retension days
find $LOG_DIR -type f -name $EXTENSION -mtime +$RETENTION -print -exec rm -f {} \;

echo "[$(date)] cleanup complete."
