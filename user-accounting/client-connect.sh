#!/bin/sh

# Copyright Josh Cepek
# This file is part of the openvpn-dynamic project, available from:
# https://github.com/QueuingKoala/openvpn-dynamic
# Dual-licensed under GPLv3 and BSD-3-clause

# BEGIN User Connect Accounting

log_file="/var/log/openvpn/remote.connect"

# Vars used:
date_now="$(date +'%F-%H:%M')"

line="User '$common_name'"
line+=" at $date_now"
line+=" using $ifconfig_pool_remote_ip"
line+=" from ${trusted_ip}:${trusted_port}"

# Append to the log
echo "$line" >> "$log_file"

# END User Connect Accounting

exit 0
