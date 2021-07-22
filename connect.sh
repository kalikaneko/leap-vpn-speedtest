#!/bin/zsh
echo "asking for sudo to launch openvpn..."
sudo true
for i in {1..10}; do; speedtest-cli; done | tee baseline-`date +%m_%d_%H_%M`.log
mkdir -p /tmp/certs
curl --silent https://api.float.bitmask.net/ca.crt > /tmp/certs/cacert.pem
curl --silent https://api.float.bitmask.net/3/cert > /tmp/certs/openvpn.pem
echo
echo "Now launching OpenVPN with sudo..."
sudo openvpn \
    --verb 3 \
    --tls-cipher TLS-ECDHE-ECDSA-WITH-AES-256-GCM-SHA384 \
    --cipher AES-256-GCM \
    --dev tun --client --tls-client \
    --remote-cert-tls server --tls-version-min 1.2 \
    --ca /tmp/certs/cacert.pem --cert /tmp/certs/openvpn.pem --key /tmp/certs/openvpn.pem \
    --proto tcp4 \
    --pull-filter ignore ifconfig-ipv6 \
    --pull-filter ignore route-ipv6 \
    --rcvbuf 0 --sndbuf 0 \
    --remote $GATEWAY 1194 tcp4 &

sleep 10
for i in {1..10}; do; speedtest-cli; done | tee data-`date +%m_%d_%H_%M`.log
sudo pkill -9 openvpn
