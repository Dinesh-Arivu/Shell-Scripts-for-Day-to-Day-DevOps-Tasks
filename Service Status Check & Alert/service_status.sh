#!/bin/bash
# Service Status Monitor & Alert Script

SERVICES=("nginx" "mysql" "apache2" "docker" "jenkins")   # Add services you want to monitor
EMAIL="admin@example.com"

for service in "${SERVICES[@]}"; do
    if systemctl is-active --quiet "$service"; then
        echo "✅ $service is running on $(hostname)"
        logger "✅ $service is running on $(hostname)"
    else
        message="❌ ALERT: $service is NOT running on $(hostname)"
        echo "$message"
        
        # Send email
        echo "$message" | mail -s "Service Alert: $service" "$EMAIL"
        
        # Log to syslog
        logger "$message"
    fi
done
