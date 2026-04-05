#!/bin/bash

set -euo pipefail

# Remove SDDM display-manager symlink — blocks greetd.service enable
rm -f /etc/systemd/system/display-manager.service

# Greeter system user for dms-greeter
tee /usr/lib/sysusers.d/greeter.conf <<'EOF'
g greeter 767
u greeter 767 "Greetd greeter"
EOF
