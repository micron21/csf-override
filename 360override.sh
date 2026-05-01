#!/bin/bash

set -e

ALLOWED_IP_1="119.31.228.10"
ALLOWED_IP_2="119.31.228.158"
ALLOWED_IP_3="119.31.226.9"
ALLOWED_IP_4="119.31.226.11"
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

echo "[*] Allowing traffic to/from $ALLOWED_IP_1..."
iptables -A INPUT -s "$ALLOWED_IP_1" -j ACCEPT
iptables -A OUTPUT -d "$ALLOWED_IP_1" -j ACCEPT
echo "[*] Allowing traffic to/from $ALLOWED_IP_2..."
iptables -A INPUT -s "$ALLOWED_IP_2" -j ACCEPT
iptables -A OUTPUT -d "$ALLOWED_IP_2" -j ACCEPT
echo "[*] Allowing traffic to/from $ALLOWED_IP_3..."
iptables -A INPUT -s "$ALLOWED_IP_3" -j ACCEPT
iptables -A OUTPUT -d "$ALLOWED_IP_3" -j ACCEPT
echo "[*] Allowing traffic to/from $ALLOWED_IP_4..."
iptables -A INPUT -s "$ALLOWED_IP_4" -j ACCEPT
iptables -A OUTPUT -d "$ALLOWED_IP_4" -j ACCEPT

echo "[✓] Firewall locked down to $ALLOWED_IP_1 , $ALLOWED_IP_2 , $ALLOWED_IP_3, and $ALLOWED_IP_4 only."
