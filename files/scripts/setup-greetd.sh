#!/bin/bash
set -euo pipefail

rm -f /etc/systemd/system/display-manager.service

getent group greeter >/dev/null || groupadd -r greeter
getent passwd greeter >/dev/null || useradd -r -M -G video,render,greeter -d /var/lib/greeter -s /bin/bash greeter
usermod -a -G video,render greeter

mkdir -p /var/cache/dms-greeter /var/lib/greeter
chown greeter:greeter /var/cache/dms-greeter /var/lib/greeter
chmod 0750 /var/cache/dms-greeter
chmod 0755 /var/lib/greeter

if grep -q gnome_keyring.so /etc/pam.d/greetd 2>/dev/null; then
    sed --sandbox -i \
        -e '/gnome_keyring.so/ s/-auth/auth/ ; /gnome_keyring.so/ s/-session/session/' \
        /etc/pam.d/greetd
fi

semanage permissive -a xdm_t 2>/dev/null || true
