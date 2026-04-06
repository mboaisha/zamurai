#!/bin/bash
set -euo pipefail

rm -f /etc/systemd/system/display-manager.service

sed --sandbox -i \
    -e '/gnome_keyring.so/ s/-auth/auth/ ; /gnome_keyring.so/ s/-session/session/' \
    /etc/pam.d/greetd

cat > /usr/lib/sysusers.d/dms-greeter.conf << 'EOF'
g greeter - "Greeter group"
u greeter - "System Greeter" /var/lib/greeter /bin/bash
EOF

cat > /usr/lib/tmpfiles.d/dms-greeter-dirs.conf << 'EOF'
d /var/cache/dms-greeter 0750 greeter greeter -
d /var/lib/greeter 0755 greeter greeter -
EOF

# SELinux screwing me again
semanage permissive -a xdm_t 2>/dev/null || true
