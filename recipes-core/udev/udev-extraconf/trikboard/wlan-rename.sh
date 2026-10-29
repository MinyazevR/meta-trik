#!/bin/sh
# Give the external USB WiFi dongle priority over the built-in radio:
# the dongle always ends up as wlan0, the built-in one is demoted to
# wlan_builtin and left without a network configuration.

set -u

IFACE="${1:-}"
[ -n "$IFACE" ] || exit 0
[ -e "/sys/class/net/$IFACE" ] || exit 0

# Check for "usb" in the device path instead of %E{ID_BUS}: ID_BUS is empty
# for devices that are initially recognized as disk.
DEVPATH="$(udevadm info -q path -n "/sys/class/net/$IFACE" 2>/dev/null || true)"
case "$DEVPATH" in
	*/usb/*|*/usb) is_usb=1 ;;
	*)             is_usb=0 ;;
esac

rename_if() {
	src="$1"
	dst="$2"

	[ "$src" = "$dst" ] && return 0
	[ -e "/sys/class/net/$src" ] || return 1
	[ -e "/sys/class/net/$dst" ] && return 1

	ip link set "$src" down >/dev/null 2>&1 || true
	ip link set "$src" name "$dst" >/dev/null 2>&1
}

final="$IFACE"

if [ "$is_usb" = 1 ] && [ "$IFACE" != "wlan0" ]; then
	# USB dongle appeared under a different name: demote the built-in
	# radio (if it currently owns wlan0), then promote the dongle.
	if [ -e /sys/class/net/wlan0 ]; then
		rename_if wlan0 wlan_builtin || true
	fi
	if rename_if "$IFACE" wlan0; then
		final="wlan0"
	fi
elif [ "$is_usb" = 0 ] && [ "$IFACE" != "wlan0" ] && [ -e /sys/class/net/wlan0 ]; then
	# Built-in radio appeared after the USB dongle already owns wlan0.
	rename_if "$IFACE" wlan_builtin || true
	final=""
fi

if [ "$final" = "wlan0" ]; then
	systemctl --no-block restart trik-wifi-mode@wlan0.service >/dev/null 2>&1 || true
fi

exit 0
