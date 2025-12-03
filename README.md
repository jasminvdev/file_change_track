## Magento Snapshot Utility Scripts

This project contains two helper shell scripts that let you take a snapshot of your Magento `app` folder and later compare it to see what changed.

- **`snapshot_create.sh`**: Creates a clean snapshot of the current Magento `app` directory.
- **`snapshot_compare.sh`**: Compares the current `app` directory with the last snapshot and logs new/changed/deleted files.

---

## 1. `snapshot_create.sh`

**Purpose**: Create a fresh snapshot (copy) of the Magento application code so you can compare future changes against it.

**Defaults**

- **Source directory**: `/var/www/html/magento/app`
- **Snapshot directory**: `/tmp/magento_project_snapshot`

**What it does**

1. Deletes any existing snapshot directory at `/tmp/magento_project_snapshot`.
2. Recreates the snapshot directory.
3. Uses `rsync` to copy everything from `magento/app` into the snapshot directory.
   - Skips `.git` directory.
   - Skips `*.log` files.

**Run**

```bash
bash /var/www/html/snapshot_create.sh
```

Run this before you start making changes, or whenever you want to reset the "baseline".

---

## 2. `snapshot_compare.sh`

**Purpose**: Compare the current Magento `app` directory with the last snapshot and write all differences to a log file.

**Defaults**

- **Source directory**: `/var/www/html/magento/app`
- **Snapshot directory**: `/tmp/magento_project_snapshot`
- **Log file**: `/var/www/html/magento/change_log.txt`

**What it detects**

- **New files** (exist in `SOURCE_DIR` but not in `SNAPSHOT_DIR`).
- **Changed files** (same relative path in both places, but content differs).
- **Deleted files** (exist in `SNAPSHOT_DIR` but not in `SOURCE_DIR`).

Each run appends to the log file with a timestamp header:

- New file: `[NEW FILE] relative/path/to/file.php`
- Changed file: `[CHANGED] relative/path/to/file.php | line => LINE_NUMBER`
- Deleted file: `[DELETED] relative/path/to/file.php`

**Run**

```bash
bash /var/www/html/snapshot_compare.sh
```

Then check the log:

```bash
cat /var/www/html/magento/change_log.txt
```

---

## 3. Typical Workflow

1. **Create snapshot (baseline)**

   ```bash
   bash /var/www/html/snapshot_create.sh
   ```

2. **Do your code changes** in `magento/app`.

3. **Compare with snapshot**

   ```bash
   bash /var/www/html/snapshot_compare.sh
   ```

4. **Review changes**

   ```bash
   less /var/www/html/magento/change_log.txt
   ```

---

## 4. Restore a Deleted File (Optional)

If a file was deleted from the project but still exists in the snapshot, you can restore it manually:

```bash
cp /tmp/magento_project_snapshot/path/to/file.php /var/www/html/magento/app/path/to/file.php
```

Adjust the paths as needed for the file you want to restore.


