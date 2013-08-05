#!/bin/sh

# Copyright 2013, Josh Cepek
# This file is part of the openvpn-dynamic project, available from:
# https://github.com/QueuingKoala/openvpn-dynamic
# Dual-licensed under GPLv3 and BSD-3-clause

# General config:
dynamic_dir="/etc/openvpn/dynamic-main"
state_dir="/var/tmp/openvpn/fw-main"
# binaries needed: use full paths if needed in your environment:
bin_restore="iptables-restore"
bin_sed="sed"

# Set this to 1 (the default) for fatal abort on failure to apply rules.
# When set to 0, the client is still allowed to connect anyway.
fw_fatal=1

# Helper-function to exit when rule assingment is fatal
abort() {
	[ -f "$sate_fw_file" ] && rm "$state_fw_file"
	[ $fw_fatal -eq 1 ] && exit $1
	exit 0
}

# state dir must exist for processing:
if [ ! -d "$state_dir" ]; then
	mkdir -p "$state_dir" || abort 9
fi

cn_fw="${dynamic_dir}/${common_name}:fw"
default_fw="${dynamic_dir}/DEFAULT:fw"
state_fw_file="${state_dir}/${ifconfig_pool_remote_ip}:fw"

# Determine if a firewall file exists for the connecting client.
# If not and a DEFAULT is present, use it.
fw_file=""
if [ -f "$cn_fw" ]; then
	fw_file="$cn_fw"
elif [ -f "$default_fw" ]; then
	fw_file="$default_fw"
fi

# Exit if no firewall file exists
[ -n "$fw_file" ] || exit 0

# Copy the file to the state directory for undoing later.
# Replace invocations of <IP> with the client's IP
"$bin_sed" "s@<IP>@$ifconfig_pool_remote_ip@" "$fw_file" > "$state_fw_file" || \
	abort 8

# Load it through iptables-restore
"$bin_restore" -n < "$state_fw_file" || abort 1

exit 0
