#!/bin/sh

. /usr/share/debconf/confmodule

hostname="automated-install-debian"
ipaddress=192.168.0.2
gateway=192.168.0.1

cat >>/tmp/preseed.cfg <<EOF
d-i netcfg/get_hostname string $hostname
d-i netcfg/get_ipaddress string $ipaddress
d-i netcfg/get_gateway string $gateway
EOF
