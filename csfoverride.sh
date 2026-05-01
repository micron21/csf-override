#!/bin/bash

set -e

CSF_DIR="/etc/csf"

echo "[*] Writing minimal csf.conf..."

cat > "${CSF_DIR}/csf.conf" <<'EOF'
# Minimal CSF configuration - deny everything

TESTING = "0"

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

csf -x   # stop
csf -e   # start

echo "[✓] CSF locked down."
