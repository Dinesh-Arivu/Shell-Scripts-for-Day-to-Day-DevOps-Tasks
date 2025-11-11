#!/bin/bash
# SSL Certificate Expiry Monitor Script

DOMAIN="example.com"
THRESHOLD=15                  # Alert if certificate expires in less than N days
EMAIL="admin@example.com"

# Detect mail command
if command -v mail >/dev/null 2>&1; then
    MAIL_CMD=$(command -v mail)
else
    MAIL_CMD=""
    echo "⚠️  'mail' command not found — email alerts disabled"
fi

# Fetch SSL expiry (timeout included)
expiry=$(timeout 5 bash -c \
    "echo | openssl s_client -servername $DOMAIN -connect $DOMAIN:443 2>/dev/null \
    | openssl x509 -noout -enddate" \
    | cut -d= -f2)

# Validate response
if [ -z "$expiry" ]; then
    echo "❌ ERROR: Failed to fetch SSL certificate for $DOMAIN"
    logger "❌ ERROR: Failed to fetch SSL certificate for $DOMAIN"
    exit 1
fi

# Convert expiry to seconds
expiry_date=$(date -d "$expiry" +%s 2>/dev/null)
current_date=$(date +%s)
days_left=$(( (expiry_date - current_date) / 86400 ))

echo "📌 SSL Expiry Date for $DOMAIN: $expiry"
echo "⏳ Days left: $days_left"

# Send alert if needed
if [ "$days_left" -le "$THRESHOLD" ]; then
    message="⚠️ ALERT: SSL certificate for $DOMAIN expires in $days_left days ($expiry)"

    # Send email only if mail exists
    if [ -n "$MAIL_CMD" ]; then
        echo "$message" | $MAIL_CMD -s "SSL Expiry Alert: $DOMAIN" "$EMAIL"
    fi

    logger "$message"
fi
