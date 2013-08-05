#!/bin/sh

# General config:
state_dir="/var/tmp/openvpn/fw-main"
# binaries needed: use full paths if needed in your environment:
bin_restore="iptables-restore"
bin_sed="sed"

# Exit if the state dir isn't present:
[ -d "$state_dir" ] || exit 9

state_fw_file="${state_dir}/${ifconfig_pool_remote_ip}:fw"
state_fw_unload="${state_fw_file}:un"

# Exit if no firewall file exists to unload
[ -f "$state_fw_file" ] || exit 0

# Replace -A and -I in the netfilter rules with -D to unload them:
"$bin_sed" 's/^-A /-D /;s/^-I /-D /' "$state_fw_file" > "$state_fw_unload"

# Load it through iptables-restore
"$bin_restore" -n < "$state_fw_unload"

# Clean up files
rm "$state_fw_file" "$state_fw_unload"
