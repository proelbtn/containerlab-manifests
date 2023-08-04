#!/bin/bash

set -e

INTERFACES=(eth1 eth2)

ip addr flush eth0

for interface in ${INTERFACES[@]}; do
    while [ "$(ip -br link | grep "$interface@")" == "" ]; do sleep 0.1; done
    echo "$interface is attached."
done

echo "all interfaces is attached."

set -x

ip addr add 192.168.0.1/24 dev eth1
ip addr add 172.16.1.254/24 dev eth2

/usr/libexec/ipsec/charon
