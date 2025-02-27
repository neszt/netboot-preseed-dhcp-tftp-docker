#!/bin/bash

set -e -x

#
# DHCP
#

touch /var/lib/dhcp/dhcpd.leases && chmod 644 /var/lib/dhcp/dhcpd.leases

if [[ -z "$IFACE" ]]; then
    echo "Error: IFACE ENV variable is not set!"
    exit 1
fi

IP_WITH_PREFIX=$(ip -4 -o addr show "$IFACE" | awk '{print $4}')
IP=$(echo "$IP_WITH_PREFIX" | cut -d/ -f1)
PREFIX=$(echo "$IP_WITH_PREFIX" | cut -d/ -f2)

if (( PREFIX > 24 )); then
    echo "Error: Only /24 or greater prefix supported! (Current: /$PREFIX)"
    exit 1
fi

NETMASK=$(ipcalc "$IP_WITH_PREFIX" | awk '/Netmask/ {print $2}')
NETWORK=$(ipcalc "$IP_WITH_PREFIX" | awk '/Network/ {print $2}' | cut -d/ -f1)
GATEWAY=$(ipcalc "$IP_WITH_PREFIX" | awk '/HostMin/ {print $2}')
BROADCAST=$(ipcalc "$IP_WITH_PREFIX" | awk '/Broadcast/ {print $2}')

IFS=. read -r a b c d <<< "$NETWORK"
DHCP_RANGE_START="$a.$b.$c.200"
DHCP_RANGE_END="$a.$b.$c.250"

DHCP_DNS="8.8.8.8"
TFTP_SERVER="$IP"

cd /etc/dhcp

sed -i "s/DHCP_SUBNET/$NETWORK/g" dhcpd.conf
sed -i "s/DHCP_NETMASK/$NETMASK/g" dhcpd.conf
sed -i "s/DHCP_GATEWAY/$GATEWAY/g" dhcpd.conf
sed -i "s/DHCP_BROADCAST/$BROADCAST/g" dhcpd.conf
sed -i "s/DHCP_RANGE_START/$DHCP_RANGE_START/g" dhcpd.conf
sed -i "s/DHCP_RANGE_END/$DHCP_RANGE_END/g" dhcpd.conf
sed -i "s/DHCP_DNS/$DHCP_DNS/g" dhcpd.conf
sed -i "s/TFTP_SERVER/$TFTP_SERVER/g" dhcpd.conf

echo "DHCP config:"
cat dhcpd.conf

#
# Custom initrd
#

INITRD=/srv/tftp/debian-installer/amd64/initrd.gz

cd /tmp

zcat $INITRD | cpio -i
cp -va /data/pre* /data/post* /tmp/
find . | cpio -H newc -o | gzip -c1 > $INITRD

#
# SUPERVISOR
#

sed -i "s/__IFACE__/$IFACE/g" /etc/supervisor/supervisord.conf
sed -i "s/__IP__/$IP/g" /etc/supervisor/supervisord.conf

/usr/bin/supervisord -c /etc/supervisor/supervisord.conf
