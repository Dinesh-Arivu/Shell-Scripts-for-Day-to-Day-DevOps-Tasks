#!/bin/bash
# ==========================================================
#  FULL SERVER MONITOR: DISK + CPU + MEMORY (Email/Slack/Telegram)
# ==========================================================

# ---------- CONFIG ----------
THRESHOLD_CPU=80         # CPU %
THRESHOLD_MEM=80         # Memory %
THRESHOLD_DISK=80        # Disk %

EMAIL="admin@example.com"

# Slack Webhook (optional)
SLACK_WEBHOOK="https://hooks.slack.com/services/XXXX/YYYY/ZZZZ"

# Telegram Bot Details (optional)
TELEGRAM_BOT_TOKEN="123456789:ABCDEF..."
TELEGRAM_CHAT_ID="123456789"

HOST=$(hostname)

# Detect mail command
if command -v mail >/dev/null 2>&1; then
    MAIL_CMD=$(command -v mail)
else
    MAIL_CMD=""
    echo "⚠️  'mail' not found — Email alerts disabled"
fi

# ---------- ALERT FUNCTION ----------
send_alert() {
    local subject="$1"
    local message="$2"

    # Email
    if [ -n "$MAIL_CMD" ]; then
        echo "$message" | $MAIL_CMD -s "$subject" "$EMAIL"
    fi

    # Slack
    if [ -n "$SLACK_WEBHOOK" ]; then
        curl -s -X POST -H 'Content-Type: application/json' \
        --data "{\"text\":\"$message\"}" "$SLACK_WEBHOOK" > /dev/null
    fi

    # Telegram
    if [ -n "$TELEGRAM_BOT_TOKEN" ]; then
        curl -s "https://api.telegram.org/bot$TELEGRAM_BOT_TOKEN/sendMessage" \
        --data "chat_id=$TELEGRAM_CHAT_ID&text=$message" > /dev/null
    fi

    # Log
    logger "$subject — $message"
}

# ==========================================================
#  ✅ CPU CHECK
# ==========================================================
CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
CPU=${CPU%.*}

echo "CPU Usage: $CPU%"

if [ "$CPU" -ge "$THRESHOLD_CPU" ]; then
    send_alert "CPU ALERT on $HOST" "⚠️ CPU Usage HIGH: $CPU%"
fi


# ==========================================================
#  ✅ MEMORY CHECK
# ==========================================================
MEM=$(free | awk '/Mem/ {print int($3/$2 * 100)}')

echo "Memory Usage: $MEM%"

if [ "$MEM" -ge "$THRESHOLD_MEM" ]; then
    send_alert "Memory ALERT on $HOST" "⚠️ Memory Usage HIGH: $MEM%"
fi


# ==========================================================
#  ✅ DISK CHECK
# ==========================================================
df -P -x tmpfs -x devtmpfs -x squashfs | awk 'NR>1 {print $6, $5}' | while read mount usage; do
    usage_percent=$(echo "$usage" | tr -d '%')

    echo "Disk: $mount → $usage_percent%"

    if [ "$usage_percent" -ge "$THRESHOLD_DISK" ]; then
        send_alert "Disk ALERT on $HOST" "⚠️ Disk HIGH\nMount: $mount\nUsage: $usage_percent%"
    fi
done
