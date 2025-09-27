#!/bin/bash
# Docker Container Monitor Script

EMAIL="admin@example.com"

# List of containers that must always be running
REQUIRED_CONTAINERS=("webapp" "db" "redis")

# --- Check Docker Installed ---
if ! command -v docker &>/dev/null; then
    echo "❌ Docker not installed"
    exit 1
fi

echo "📦 Running Docker Containers on $(hostname):"
docker ps --format "table {{.Names}}\t{{.Status}}"

# --- Verify Required Containers ---
for container in "${REQUIRED_CONTAINERS[@]}"; do
    if ! docker ps --format '{{.Names}}' | grep -qw "$container"; then
        message="⚠️ ALERT: Container $container is NOT running on $(hostname)"
        echo "$message"

        # Send email alert
        echo "$message" | mail -s "Docker Alert: $container" "$EMAIL"

        # Log to syslog
        logger "$message"
    fi
done
