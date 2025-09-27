#!/bin/bash
# CPU & Memory Usage Monitor Script

THRESHOLD_CPU=80   # % CPU threshold
THRESHOLD_MEM=80   # % Memory threshold
EMAIL="admin@example.com"

# --- CPU Usage ---
CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')   # user% + system%
CPU=$(printf "%.2f" "$CPU")

# --- Memory Usage ---
MEM=$(free | awk '/Mem/ {printf "%.2f", $3/$2 * 100.0}')

# --- Output ---
echo "CPU Usage: $CPU%"
echo "Memory Usage: $MEM%"

# --- Alerts ---
if (( $(echo "$CPU > $THRESHOLD_CPU" | bc -l) )); then
    message="⚠️ High CPU usage on $(hostname): ${CPU}%"
    echo "$message" | mail -s "CPU Alert" "$EMAIL"
    logger "$message"
fi

if (( $(echo "$MEM > $THRESHOLD_MEM" | bc -l) )); then
    message="⚠️ High Memory usage on $(hostname): ${MEM}%"
    echo "$message" | mail -s "Memory Alert" "$EMAIL"
    logger "$message"
fi
# --- End of Script --- 