#!/bin/sh

. /usr/share/debconf/confmodule

mkdir /root/.ssh
cat > /root/.ssh/authorized_keys <<EOF
ssh-rsa AAAA......
EOF

sed -i -e '/^#PasswordAuthentication/{ s/^#//; s/yes/no/ }' /etc/ssh/sshd_config

rm -f "$0"
