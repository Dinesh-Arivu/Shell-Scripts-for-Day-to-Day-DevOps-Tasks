#!/bin/bash
# Simple Log Rotation Script with Auto-Cleanup

LOGFILE="/var/log/myapp.log"
ARCHIVE="/var/log/archive"

# Create archive directory if not exists
mkdir -p "$ARCHIVE"

# Check if log exists
if [ -f "$LOGFILE" ]; then
    TIMESTAMP=$(date +%F_%H-%M-%S)
    mv "$LOGFILE" "$ARCHIVE/myapp-$TIMESTAMP.log"
    touch "$LOGFILE"
    chmod 644 "$LOGFILE"
    echo "✅ Log rotated: $ARCHIVE/myapp-$TIMESTAMP.log"

    # Auto-cleanup logs older than 7 days
    find "$ARCHIVE" -type f -name "myapp-*.log" -mtime +7 -exec rm {} \;
    echo "🧹 Old logs older than 7 days removed."
else
    echo "⚠️ Log file $LOGFILE not found!"
fi
# End of script