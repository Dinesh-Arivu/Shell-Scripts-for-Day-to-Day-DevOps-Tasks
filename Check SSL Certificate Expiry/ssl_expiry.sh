#!/bin/bash
# SSL Certificate Expiry Monitor Script

DOMAIN="example.com"
THRESHOLD=15                 # Alert if certificate expires in less than N days
EMAIL="admin@example.com"

expiry=$(echo | openssl s_client -servername $DOMAIN -connect $DOMAIN:443 2>/dev/null \
    | openssl x509 -noout -enddate | cut -d= -f2)

if [ -z "$expiry" ]; then
    echo "❌ Failed to fetch SSL certificate for $DOMAIN"
    exit 1
fi

expiry_date=$(date -d "$expiry" +%s)
current_date=$(date +%s)
days_left=$(( (expiry_date - current_date) / 86400 ))

echo "📌 SSL Expiry Date for $DOMAIN: $expiry"
echo "⏳ Days left: $days_left"

if [ "$days_left" -le "$THRESHOLD" ]; then
    message="⚠️ ALERT: SSL certificate for $DOMAIN expires in $days_left days ($expiry)"
    echo "$message" | mail -s "SSL Expiry Alert: $DOMAIN" "$EMAIL"
    logger "$message"
fi
