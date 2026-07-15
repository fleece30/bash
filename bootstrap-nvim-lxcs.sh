#!/usr/bin/env bash
set -euo pipefail

SCRIPT_URL="https://raw.githubusercontent.com/fleece30/bash/refs/heads/master/install-nvim.sh"

for LXID in $(pct list | awk 'NR>1 {print $1}'); do
	STATUS=$(pct status "$LXID" | awk '{print $2}')
	if [ "$STATUS" != "running" ]; then
		echo "skipping $LXID (not running)"
		continue
	fi
	echo "==> Bootstrapping nvim in LXC $LXID..."
	pct exec "$LXID" -- bash -c "curl -fsSL $SCRIPT_URL | bash"
done

echo "All running LXCs bootstrapped with nvim."
