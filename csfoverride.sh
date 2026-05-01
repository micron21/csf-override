#!/bin/bash

set -e

CSF_DIR="/etc/csf"
echo "[*] Backing up csf.confs..."
cp "${CSF_DIR}/csf.conf" "${CSF_DIR}/csf.conf.backup"
cp "${CSF_DIR}/csf.allow" "${CSF_DIR}/csf.allow.backup"
cp "${CSF_DIR}/csf.deny" "${CSF_DIR}/csf.deny.backup"
echo "[*] Writing minimal csf.conf..."

cat > "${CSF_DIR}/csf.conf" <<'EOF'
# Minimal CSF configuration - deny everything

TESTING = "0"
IPTABLES = "/usr/sbin/iptables"
IPTABLES_SAVE = "/usr/sbin/iptables-save"
IPTABLES_RESTORE = "/usr/sbin/iptables-restore"
IP6TABLES = "/usr/sbin/ip6tables"
IP6TABLES_SAVE = "/usr/sbin/ip6tables-save"
IP6TABLES_RESTORE = "/usr/sbin/ip6tables-restore"

# Disable all inbound/outbound ports
TCP_IN = ""
TCP_OUT = ""
UDP_IN = ""
UDP_OUT = ""

# ICMP (ping)
ICMP_IN = "0"
ICMP_OUT = "0"

# Connection tracking
CT_LIMIT = "0"

# Allow loopback
LF_ALLOWLOCAL = "1"
EOF

echo "[*] Writing csf.allow..."

cat > "${CSF_DIR}/csf.allow" <<'EOF'
# Only allowed IPs
119.31.228.10
119.31.228.158
EOF

echo "[*] Writing csf.deny..."

cat > "${CSF_DIR}/csf.deny" <<'EOF'
# Deny everything else (implicit)
EOF

echo "[*] Restarting CSF..."

csf -e   # start if disabled
csf -r   # restart
csf -l   # list

echo "[✓] CSF locked down."
