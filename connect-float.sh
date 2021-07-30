#!/bin/sh
set +x
set +e

echo "TRANSPORT:" $TRANSPORT

sudo openvpn \
    --verb 4 \
    --tls-cipher DHE-RSA-AES128-SHA \
    --cipher AES-128-CBC \
    --dev tun --client --tls-client \
    --remote-cert-tls server --tls-version-min 1.2 \
    --ca /tmp/certs/cacert.pem --cert /tmp/certs/openvpn.pem --key /tmp/certs/openvpn.pem \
    --pull-filter ignore ifconfig-ipv6 \
    --pull-filter ignore route-ipv6 \
    --remote 204.13.164.252 1194 ${TRANSPORT} \
    --rcvbuf 0 --sndbuf 0 \
    --persist-tun \
