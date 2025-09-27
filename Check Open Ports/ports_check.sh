#!/bin/bash
# Port Monitoring Script

PORTS="22 80 443"           # Ports to check
HOST="localhost"            # Target host
EMAIL="admin@example.com"   # Email for alerts

for port in $PORTS; do
    if nc -z -w2 $HOST $port 2>/dev/null; then
        echo "✅ Port $port is OPEN on $HOST"
    else
        echo "❌ Port $port is CLOSED on $HOST"

        # Send alert
        message="ALERT: Port $port is CLOSED on $HOST"
        echo "$message" | mail -s "Port Alert: $port" "$EMAIL"

        # Log to syslog
        logger "$message"
    fi
done
# End of script