# Persistence Checks

## Modified CRON
crontab -l
find /etc/cron* -mtime -4 -type f

## New Executables
find /tmp /var/tmp /dev/shm /root -type f -mtime -4 -executable -ls

## Modified SSH Access
find /home/*/.ss* -type f -mtime -4

## Modified User Passwords (will show up if we've rolled the password
find /etc/group -type f -mtime -4
find /etc/shadow -type f -mtime -4
cat /etc/shadow

## Check history
history | tail -n 50

## Modified user profile files
find /home/*/.b* -type f -mtime -4

## Review lastlog
lastlog | grep 2026

## Investigate Processes - a lot of false positives probably
lsof -i -n -P

## Search for shells (takes a long time, only do this if we are sus from other activity)
grep -R --line-number -E "nc -e|/bin/sh|/bin/bash|bash -i|python -c|perl -e|php -r|/dev/tcp|socat|mkfifo" / 2>/dev/null
