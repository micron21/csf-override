# firewall-override for cPanel compromise
quick CSF override repository

# usage:

```
git clone https://github.com:micron21/csf-override.git

cd csf-override/
```

# Then check for cpanel compromise:

```
chmod +x ioc_checksessions_files.sh

./ioc_checksessions_files.sh
```

# If compromised:

```
chmod +x csfoverride.sh

./csfoverride.sh
```

