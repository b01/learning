#!/bin/sh

# We'll use this script to manage starting and stopping this container gracefully.
# It only takes up about 00.01 CPU % allotted to the container, you can verify
# by running `docker stats` after you start a container that uses this as
# as the CMD.

set -e

shutd () {
    printf "%s" "Shutting down the container gracefully..."
    # You can run clean commands here!
    last_signal="15"
}

trap 'shutd' TERM

echo "Ready!"

# Extract IP addresses from the ip tool.
iface="eth0"
export IPv4=$(ip -4 addr show scope global dev ${iface} | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)
export IPv6=$(ip -6 addr show scope global dev ${iface} | grep "inet6\b" | awk '{print $2}' | cut -d/ -f1)
sans="DNS:localhost,DNS:app1,DNS:app2,IP:127.0.0.1"

# Build SANs
if [ -n "${IPv4}" ]; then
  sans="${sans},IP:${IPv4}"
fi

if [ -n "${IPv6}" ]; then
  sans="${sans},IP:${IPv6}"
fi

# Run non-blocking commands here
gen-ss-cert.sh --company="containers" \
    --sans=${sans} \
    --out-dir="${HOME}/pki" \
    "localhost" \
    --cert-ext "crt"

app ${HOME}/src/github.com/b01/learning/golang/webapp-pinger &

# This keeps the container running until it receives a signal to be stopped.
# Also very low CPU usage.
while [ "${last_signal}" != "15" ]; do
    sleep 1
done

echo "done"
