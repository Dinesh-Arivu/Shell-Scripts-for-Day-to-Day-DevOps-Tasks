#!/bin/bash
# Directory Backup Script

# === CONFIG ===
SOURCE="/var/www/html"              # Directory to backup
DEST="/backup"                      # Backup destination directory
RETENTION=7                         # Days to keep backups
EMAIL="admin@example.com"           # Alert email

# === CREATE BACKUP ===
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
FILENAME="backup-$(basename $SOURCE)-$DATE.tar.gz"
BACKUP_PATH="$DEST/$FILENAME"

mkdir -p "$DEST"

tar -czf "$BACKUP_PATH" "$SOURCE"

if [ $? -eq 0 ]; then
    message="✅ Backup successful: $BACKUP_PATH"
else
    message="❌ Backup FAILED for $SOURCE on $(hostname)"
fi

# Send email alert
echo "$message" | mail -s "Backup Report: $(hostname)" "$EMAIL"

# Log to syslog
logger "$message"

# === CLEAN OLD BACKUPS ===
find "$DEST" -type f -name "backup-*.tar.gz" -mtime +$RETENTION -exec rm {} \;
