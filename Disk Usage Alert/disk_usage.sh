#!/bin/bash
# Disk Usage Monitor & Alert Script

THRESHOLD=80                # % threshold
EMAIL="admin@example.com"   # Alert email

# Check all mounted filesystems (except tmpfs & devtmpfs)
df -P -x tmpfs -x devtmpfs | awk 'NR>1 {print $6, $5}' | while read mount usage; do
    usage_percent=$(echo "$usage" | sed 's/%//')

    if [ "$usage_percent" -ge "$THRESHOLD" ]; then
        message="⚠️ Disk usage alert on $(hostname)
Mount: $mount
Usage: $usage"

        # Send email alert
        echo "$message" | mail -s "Disk Alert: $mount" "$EMAIL"

        # Log to syslog
        logger "$message"
    fi
done
