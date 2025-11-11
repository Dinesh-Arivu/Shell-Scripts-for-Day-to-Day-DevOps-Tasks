#!/bin/bash
# Directory Backup Script

# === CONFIG ===
SOURCE="/var/www/html"              # Directory to backup
DEST="/backup"                      # Backup destination directory
RETENTION=7                         # Days to keep backups
EMAIL="admin@example.com"           # Alert email
MAIL_CMD="/usr/bin/mail"            # Mail command path (auto-detected later)

# === CHECKS ===

# Check if SOURCE exists
if [ ! -d "$SOURCE" ]; then
    echo "❌ ERROR: Source directory $SOURCE does not exist!"
    exit 1
fi

# Detect mail binary (fix for 'mail: command not found')
if ! command -v mail > /dev/null 2>&1; then
    echo "⚠️  WARNING: 'mail' command not found. Email alerts disabled."
    MAIL_CMD=""
else
    MAIL_CMD=$(command -v mail)
fi

mkdir -p "$DEST"

# === CREATE BACKUP ===
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
FILENAME="backup-$(basename $SOURCE)-$DATE.tar.gz"
BACKUP_PATH="$DEST/$FILENAME"

tar -czPf "$BACKUP_PATH" "$SOURCE" 2>/dev/null

if [ $? -eq 0 ]; then
    message="✅ Backup successful: $BACKUP_PATH"
else
    message="❌ Backup FAILED for $SOURCE on $(hostname)"
fi

# === SEND EMAIL ONLY IF MAIL EXISTS ===
if [ -n "$MAIL_CMD" ]; then
    echo "$message" | $MAIL_CMD -s "Backup Report: $(hostname)" "$EMAIL"
fi

# Log to syslog
logger "$message"

# === CLEAN OLD BACKUPS ===
find "$DEST" -type f -name "backup-*.tar.gz" -mtime +$RETENTION -delete

echo "$message"
