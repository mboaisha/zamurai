#!/bin/bash
set -euo pipefail

# Remove SDDM display-manager symlink — blocks greetd.service enable
rm -f /etc/systemd/system/display-manager.service

# Fix PAM config for gnome-keyring
sed --sandbox -i \
    -e '/gnome_keyring.so/ s/-auth/auth/ ; /gnome_keyring.so/ s/-session/session/' \
    /etc/pam.d/greetd

# Create greeter home and cache directories on every boot.
# RPM %post can't persist /var in ostree images, so we use tmpfiles.d instead.
cat > /usr/lib/tmpfiles.d/dms-greeter-dirs.conf << 'EOF'
d /var/cache/dms-greeter 0750 greeter greeter -
d /var/lib/greeter 0755 greeter greeter -
EOF
