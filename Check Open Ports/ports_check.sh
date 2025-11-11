#!/bin/bash
# Port Monitoring Script

PORTS="22 80 443 8080 3000 3306"            # Ports to check
HOST="localhost"             # Target host
EMAIL="admin@example.com"    # Email for alerts

# Detect mail command
if command -v mail >/dev/null 2>&1; then
    MAIL_CMD=$(command -v mail)
else
    MAIL_CMD=""
    echo "⚠️ 'mail' command not found — email alerts disabled"
fi

# Detect nc command
if ! command -v nc >/dev/null 2>&1; then
    echo "❌ ERROR: 'nc' (netcat) is not installed!"
    echo "Install with:"
    echo "  sudo apt install netcat-openbsd    # Ubuntu/Debian"
    echo "  sudo yum install nc                # CentOS/RHEL"
    exit 1
fi

for port in $PORTS; do
    if nc -z -w2 $HOST $port 2>/dev/null; then
        echo "✅ Port $port is OPEN on $HOST"
    else
        echo "❌ Port $port is CLOSED on $HOST"

        message="ALERT: Port $port is CLOSED on $HOST"

        # Send alert only if mail exists
        if [ -n "$MAIL_CMD" ]; then
            echo "$message" | $MAIL_CMD -s "Port Alert: $port" "$EMAIL"
        fi

        # Log to syslog
        logger "$message"
    fi
done
