#!/bin/bash

set -e

CSF_DIR="/etc/csf"
echo "[*] Restoring csf.confs..."
cp "${CSF_DIR}/csf.conf.backup" "${CSF_DIR}/csf.conf"
cp "${CSF_DIR}/csf.allow.backup" "${CSF_DIR}/csf.allow"
cp "${CSF_DIR}/csf.deny.backup" "${CSF_DIR}/csf.deny"

echo "[*] Restarting CSF..."

csf -e   # start if disabled
csf -r   # restart
csf -l   # list

echo "[✓] CSF restores."
