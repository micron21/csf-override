#!/bin/bash

set -e

BACKUP_DIR="/root/iptables-backup"

echo "[*] Restoring latest iptables backup rules..."

LATEST=$(ls -1t "$BACKUP_DIR"/iptables-*.rules 2>/dev/null | head -n 1)
iptables-restore < "$LATEST"

echo "[*] Restarting Imunify360..."
systemctl stop imunify360 || true

systemctl start imunify360 || true

echo "[✓] Firewall restored."
