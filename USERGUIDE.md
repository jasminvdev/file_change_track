## User Guide – Magento Snapshot Scripts

This guide explains, in simple steps, how to use the two scripts:

- `snapshot_create.sh`
- `snapshot_compare.sh`

These scripts help you track code changes inside your Magento `app` folder.

---

## 1. Before You Start

- Make sure your Magento project is located at:
  - `/var/www/html/magento`
- Scripts should be in:
  - `/var/www/html/snapshot_create.sh`
  - `/var/www/html/snapshot_compare.sh`
- You need permission to:
  - Read: `/var/www/html/magento/app`
  - Write: `/tmp` and `/var/www/html/magento/change_log.txt`

If needed, you can run commands with `sudo` (for example: `sudo bash /var/www/html/snapshot_create.sh`).

---

## 2. Taking a Snapshot (Baseline)

You usually do this **before** starting changes.

1. Open a terminal on the server.
2. Run:

   ```bash
   bash /var/www/html/snapshot_create.sh
   ```

3. You should see a message similar to:
   - `Creating snapshot from /var/www/html/magento/app...`
   - `✅ Snapshot created at /tmp/magento_project_snapshot`

This snapshot is your **baseline**. Later you will compare against this.

---

## 3. Working on Your Changes

After the snapshot:

1. Edit files as usual in:
   - `/var/www/html/magento/app`
2. Add, modify, or delete files as part of your development work.

There is nothing special to do with the scripts during this step.

---

## 4. Checking What Changed

When you want to see what changed compared to the snapshot:

1. Open a terminal.
2. Run:

   ```bash
   bash /var/www/html/snapshot_compare.sh
   ```

3. The script will:
   - Look at your current `magento/app` folder.
   - Compare it with the snapshot in `/tmp/magento_project_snapshot`.
   - Append a report to the log file:
     - `/var/www/html/magento/change_log.txt`
4. You should see a message:
   - `🔍 Comparing files...`
   - `✅ Comparison complete. Log saved to /var/www/html/magento/change_log.txt`

---

## 5. Reading the Change Log

To view the logged changes:

```bash
cat /var/www/html/magento/change_log.txt
```

or:

```bash
less /var/www/html/magento/change_log.txt
```

You will see lines like:

- `[NEW FILE] path/to/file.php`
- `[CHANGED] path/to/file.php | line => 45`
- `[DELETED] path/to/file.php`

**Meaning:**

- **NEW FILE**: File was added after the snapshot.
- **CHANGED**: File content changed; `line => N` shows which line(s) changed.
- **DELETED**: File existed in the snapshot but is now missing.

---

## 6. Creating a New Baseline

If you are happy with your changes and want to make them the new "baseline":

1. Run the snapshot script again:

   ```bash
   bash /var/www/html/snapshot_create.sh
   ```

2. This will delete the old snapshot and create a new one from your current code.

Next time you run `snapshot_compare.sh`, it will compare against this new baseline.

---

## 7. Restoring a Deleted File (Optional)

If a file was deleted from the project but still exists in the snapshot, you can restore it manually:

1. Find the file path in the change log (marked as `[DELETED]`).
2. Copy it from the snapshot back to the project, for example:

   ```bash
   cp /tmp/magento_project_snapshot/path/to/file.php /var/www/html/magento/app/path/to/file.php
   ```

3. Replace `path/to/file.php` with the actual path shown in the log.

---

## 8. Quick Summary (Cheat Sheet)

- **Create baseline snapshot**

  ```bash
  bash /var/www/html/snapshot_create.sh
  ```

- **Compare current code with snapshot**

  ```bash
  bash /var/www/html/snapshot_compare.sh
  ```

- **View change log**

  ```bash
  less /var/www/html/magento/change_log.txt
  ```

Use these three commands regularly to track exactly what changed in your Magento `app` folder. 


