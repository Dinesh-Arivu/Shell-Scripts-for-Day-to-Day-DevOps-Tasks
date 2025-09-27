#!/bin/bash
# Simple Application Deployment Script

APP_DIR="/opt/myapp"
SERVICE="myapp"
BRANCH="main"
EMAIL="admin@example.com"

cd "$APP_DIR" || { echo "❌ Cannot access $APP_DIR"; exit 1; }

# Pull latest changes
echo "🔄 Pulling latest code from branch: $BRANCH"
if git pull origin "$BRANCH"; then
    echo "✅ Code updated successfully."
else
    echo "❌ Git pull failed!"
    echo "Git pull failed in $APP_DIR on $(hostname)" | mail -s "Deployment Failed" "$EMAIL"
    exit 1
fi

# Restart service
echo "🔄 Restarting service: $SERVICE"
if systemctl restart "$SERVICE"; then
    echo "✅ Service restarted successfully."
    echo "Deployment successful for $SERVICE on $(hostname)" | mail -s "Deployment Success" "$EMAIL"
else
    echo "❌ Failed to restart $SERVICE!"
    echo "Service restart failed for $SERVICE on $(hostname)" | mail -s "Deployment Failed" "$EMAIL"
    exit 1
fi

echo "🚀 Deployment done."
