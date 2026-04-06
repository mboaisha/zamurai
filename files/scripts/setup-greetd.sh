#!/bin/bash
set -euo pipefail

# Remove SDDM display-manager symlink — blocks greetd.service enable
rm -f /etc/systemd/system/display-manager.service

# Fix PAM config for gnome-keyring (avoids long login times with fingerprint)
sed --sandbox -i \
    -e '/gnome_keyring.so/ s/-auth/auth/ ; /gnome_keyring.so/ s/-session/session/' \
    /etc/pam.d/greetd
