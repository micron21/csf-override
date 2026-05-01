#!/bin/bash

set -e

# Modified CRON
crontab -l
find /etc/cron* -mtime -4 -type f

# New Executables
find /tmp /var/tmp /dev/shm /root -type f -mtime -4 -executable -ls

# Modified SSH Access
find /home/*/.ssh/authorized_keys -type f -mtime -4
find /home/*/.ssh/authorized_keys2 -type f -mtime -4
find /home/*/.ss* -type f -mtime -4

# Modified User Passwords (will show up if we've rolled the password
find /etc/group -type f -mtime -4
find /etc/shadow -type f -mtime -4

# Modified user profile files
find /home/*/.b* -type f -mtime -4

# Review lastlog
lastlog | grep 2026

# Open Connections
netstat -antp | grep ESTABLISHED | grep 443
netstat -antpu | grep ESTABLISHED | grep 53

# Investigate Processes - a lot of false positives probably
pstree -ap
lsof -i -n -P

# Search for shells (takes a long time)
grep -R --line-number -E "nc -e|/bin/sh|/bin/bash|bash -i|python -c|perl -e|php -r|/dev/tcp|socat|mkfifo" / 2>/dev/null
