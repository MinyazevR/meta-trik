#!/bin/sh
set -eu

mode="${1:-}"

case "$mode" in
	station|ap) ;;
	*) echo "usage: $0 station|ap" >&2; exit 1 ;;
esac

install -d /etc/systemd/network
ln -sfn "/usr/share/trik/networkd/wifi-${mode}.network" /etc/systemd/network/20-wifi.network
networkctl reload
networkctl reconfigure wlan0 2>/dev/null || true
