#!/bin/bash

SOURCE_DIR="/var/www/html/magento/app"   # 👈 directory tame watch karso
SNAPSHOT_DIR="/tmp/magento_project_snapshot" # 👈 snapshot jya save thase

echo "Creating snapshot from $SOURCE_DIR..."
rm -rf "$SNAPSHOT_DIR"
mkdir -p "$SNAPSHOT_DIR"

rsync -a --exclude='.git' --exclude='*.log' "$SOURCE_DIR/" "$SNAPSHOT_DIR/"

echo "✅ Snapshot created at $SNAPSHOT_DIR"
