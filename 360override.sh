#!/bin/bash

set -e

ALLOWED_IP="119.31.228.10"
BACKUP_DIR="/root/iptables-backup"
TIMESTAMP=$(date +%Y%m%d-%H%M%S)

mkdir -p "$BACKUP_DIR"

echo "[*] Backing up current iptables rules..."
iptables-save > "$BACKUP_DIR/iptables-$TIMESTAMP.rules"

echo "[*] Stopping Imunify360 (to prevent rule override)..."
systemctl stop imunify360 || true

echo "[*] Flushing existing rules..."
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X
iptables -t mangle -F
iptables -t mangle -X

echo "[*] Setting default policies to DROP..."
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT DROP

echo "[*] Allowing loopback..."
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

echo "[*] Allowing established connections..."
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

echo "[*] Allowing traffic to/from $ALLOWED_IP..."
iptables -A INPUT -s "$ALLOWED_IP" -j ACCEPT
iptables -A OUTPUT -d "$ALLOWED_IP" -j ACCEPT

echo "[✓] Firewall locked down to $ALLOWED_IP only."
