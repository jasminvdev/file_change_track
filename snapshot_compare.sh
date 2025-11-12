#!/bin/bash

SOURCE_DIR="/var/www/html/magento/app"     # same directory
SNAPSHOT_DIR="/tmp/magento_project_snapshot"   # snapshot jya save chhe
LOG_FILE="/var/www/html/magento/change_log.txt"     # log output file

echo "🔍 Comparing files..."
echo "----- $(date '+%Y-%m-%d %H:%M:%S') -----" >> "$LOG_FILE"

# find all files in source dir
find "$SOURCE_DIR" -type f | while read FILE; do
    # get relative path for matching snapshot
    REL_PATH="${FILE#$SOURCE_DIR/}"
    SNAP_FILE="$SNAPSHOT_DIR/$REL_PATH"

    # check if file missing in snapshot (new file)
    if [ ! -f "$SNAP_FILE" ]; then
        echo "[NEW FILE] $REL_PATH" >> "$LOG_FILE"
        continue
    fi

    # check for difference
    DIFF_OUTPUT=$(diff -U0 "$SNAP_FILE" "$FILE" | grep '^@@' | sed -E 's/.*\+([0-9]+).*/\1/')
    if [ -n "$DIFF_OUTPUT" ]; then
        for LINE in $DIFF_OUTPUT; do
            echo "[CHANGED] $REL_PATH | line => $LINE" >> "$LOG_FILE"
        done
    fi
done

# check for deleted files
find "$SNAPSHOT_DIR" -type f | while read OLD_FILE; do
    REL_PATH="${OLD_FILE#$SNAPSHOT_DIR/}"
    if [ ! -f "$SOURCE_DIR/$REL_PATH" ]; then
        echo "[DELETED] $REL_PATH" >> "$LOG_FILE"
    fi
done

#cp /tmp/project_snapshot/path/to/file.php /path/to/your/project/path/to/file.php #for restore deleted file

echo "✅ Comparison complete. Log saved to $LOG_FILE"
