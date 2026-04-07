#!/bin/bash
set -euo pipefail

# Remove Bazzite's SDDM symlink
rm -f /etc/systemd/system/display-manager.service

# Ensure greetd group exists and future users get added to it
if ! grep -q '^GROUPS=.*greetd' /etc/default/useradd 2>/dev/null; then
    sed -i 's/^GROUPS=.*/GROUPS="greetd"/' /etc/default/useradd || \
    echo 'GROUPS="greetd"' >> /etc/default/useradd
fi

# Add any existing users with UID >= 1000 to greetd group
for u in $(awk -F: '$3 >= 1000 {print $1}' /etc/passwd); do
    usermod -aG greetd "$u" 2>/dev/null || true
done
