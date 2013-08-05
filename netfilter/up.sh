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

# define files used later:
fw_init="${dynamic_dir}/DEFAULT:init"

# Empty out state dir on init:
[ -d "$state_dir" ] && rm -f "${state_dir}"/*

# If a DEFAULT.init file exists, process it to init the fw.
# This is designed to flush VPN-specific chains, but can in theory do anything
# a rulefile is able to do.
[ -f "$fw_init" ] || exit 0
"$bin_restore" -n < "$fw_init"
