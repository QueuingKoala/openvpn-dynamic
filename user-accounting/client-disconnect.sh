#!/bin/sh

# Copyright Josh Cepek
# This file is part of the openvpn-dynamic project, available from:
# https://github.com/QueuingKoala/openvpn-dynamic
# Dual-licensed under GPLv3 and BSD-3-clause

# BEGIN User Disconnect Accounting

log_file="/var/log/openvpn-disconnect.log"

# Be platform friendly to both GNU and BSD-userland:
if date --help >/dev/null 2>&1; then
	get_date() { date -d "@$1" +'%F-%H:%M'; }
else
	get_date() { date -r "$1" +'%F-%H:%M'; }
fi

# Vars used in log line:
#time:
date_from="$(get_date $time_unix)"
unix_to=$(($time_unix + $time_duration))
date_to="$(get_date $unix_to)"
time_h=$(($time_duration / 3600))
time_m=$(( $time_duration % 3600 / 60 ))
#bw:
bw_up="$(( $bytes_received / 1000**2 ))\
.$(( $bytes_received % 1000**2 / 1000 ))"
bw_down="$(( $bytes_sent / 1000**2 ))\
.$(( $bytes_sent % 1000**2 / 1000 ))"


# Format the line for export:
line="User '$common_name' \
using $ifconfig_pool_remote_ip \
from $trusted_ip:$trusted_port \
for $date_from to $date_to ($time_h:$time_m) \
BW(up/down) $bw_up/$bw_down"

# Append it to the log
echo "$line" >> "$log_file"

# END User Disconnect Accounting

exit 0
