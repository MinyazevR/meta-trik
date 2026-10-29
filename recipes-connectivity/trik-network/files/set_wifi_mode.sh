#!/bin/sh
# TRIK wifi mode switch: client (wpa_supplicant + networkd DHCP) | ap (hostapd + networkd DHCPServer)
set -eu

TRIKRC=/etc/trik/trikrc
HOSTAPD_CONF=/etc/hostapd.conf
TEMPLATES=/usr/share/trik/networkd
WIFI_NETWORK=/etc/systemd/network/20-wifi.network

IFACE="${1:-}"
mode="${2:-client}"

[ -n "$IFACE" ] || { echo "set_wifi_mode: no wireless interface" >&2; exit 1; }
[ -e "/sys/class/net/${IFACE}" ] || { echo "set_wifi_mode: ${IFACE} does not exist" >&2; exit 1; }

case "$mode" in
	client|ap) ;;
	*) echo "usage: $0 <iface> client|ap" >&2; exit 1 ;;
esac

[ -f "$TRIKRC" ] || : > "$TRIKRC"
chmod 600 "$TRIKRC"

SAVED_MODE="$(sed -n 's/^trik_wifi_mode=//p' "$TRIKRC")"
SWITCHING=0

trik_get() {
	sed -n "s/^$1=//p" "$TRIKRC"
}

trik_set() {
	key=$1
	value=$2
	tmp="${TRIKRC}.tmp"
	sed "/^${key}=/d" "$TRIKRC" > "$tmp"
	printf '%s=%s\n' "$key" "$value" >> "$tmp"
	chmod 600 "$tmp"
	mv "$tmp" "$TRIKRC"
}

wait_for_socket() {
	path=$1
	tries=${2:-30}
	i=0
	while [ "$i" -lt "$tries" ]; do
		[ -S "$path" ] && return 0
		sleep 0.3
		i=$((i + 1))
	done
	return 1
}

wait_for_pidfile() {
	path=$1
	tries=${2:-30}
	i=0
	while [ "$i" -lt "$tries" ]; do
		[ -f "$path" ] && return 0
		sleep 0.3
		i=$((i + 1))
	done
	return 1
}

pid_is_alive() {
	pid=$1
	[ -n "$pid" ] && kill -0 "$pid" 2>/dev/null
}

wait_for_hostapd() {
	wait_for_pidfile /run/hostapd.pid || return 1
	pid="$(cat /run/hostapd.pid 2>/dev/null)" || return 1
	pid_is_alive "$pid"
}

set_networkd() {
	cp "${TEMPLATES}/wifi-${1}.network" "$WIFI_NETWORK"
	networkctl reload
}

ap_passphrase() {
	p="$(trik_get trik_wifi_ap_passphrase)"
	[ "${#p}" -eq 8 ] || {
		p="$(tr -dc '0-9' </dev/urandom | head -c 8)"
		[ "${#p}" -eq 8 ] || p="00000000"
		trik_set trik_wifi_ap_passphrase "$p"
	}
	printf '%s' "$p"
}

stop_current_mode() {
	case "$mode" in
		client) systemctl stop "wpa_supplicant@${IFACE}.service" 2>/dev/null || true ;;
		ap)     systemctl stop hostapd 2>/dev/null || true ;;
	esac
}

restore_mode() {
	case "${SAVED_MODE:-client}" in
		client) client_mode ;;
		ap)     ap_mode ;;
	esac
}

client_mode() {
	systemctl stop hostapd 2>/dev/null || true
	set_networkd station
	systemctl restart "wpa_supplicant@${IFACE}.service"
	wait_for_socket "/var/run/wpa_supplicant/${IFACE}" || {
		echo "set_wifi_mode: wpa_supplicant control socket did not appear" >&2
		return 1
	}
}

ap_mode() {
	pass="$(ap_passphrase)"
	ssid="$(cat /etc/hostname 2>/dev/null || true)"
	[ -n "$ssid" ] || ssid="trik"
	cat > "$HOSTAPD_CONF" <<EOF
interface=$IFACE
driver=nl80211
ssid=$ssid
hw_mode=g
channel=1
macaddr_acl=0
auth_algs=1
ignore_broadcast_ssid=0
wpa=2
wpa_passphrase=$pass
wpa_key_mgmt=WPA-PSK
wpa_pairwise=TKIP
rsn_pairwise=CCMP
EOF
	chmod 600 "$HOSTAPD_CONF"
	systemctl stop "wpa_supplicant@${IFACE}.service" 2>/dev/null || true
	set_networkd ap
	systemctl restart hostapd
	wait_for_hostapd || {
		echo "set_wifi_mode: hostapd did not start" >&2
		return 1
	}
}

sigterm_handler() {
	trap '' SIGTERM SIGINT
	echo "set_wifi_mode: cancelled, restoring '${SAVED_MODE:-client}'" >&2

	stop_current_mode
	restore_mode || true
	trik_set trik_wifi_mode "${SAVED_MODE:-client}" || true
	SWITCHING=0
	exit 2
}

restore_on_exit() {
	rc=$?
	trap - EXIT
	[ "$rc" -eq 0 ] && return
	[ "$SWITCHING" = "1" ] || return

	SWITCHING=0
	trap '' SIGTERM SIGINT
	echo "set_wifi_mode: switch failed, restoring '${SAVED_MODE:-client}'" >&2

	stop_current_mode
	restore_mode || true
	trik_set trik_wifi_mode "${SAVED_MODE:-client}" || true
}

trap restore_on_exit EXIT
trap sigterm_handler SIGTERM SIGINT

SWITCHING=1

case "$mode" in
	client) client_mode ;;
	ap)     ap_mode ;;
esac

trik_set trik_wifi_mode "$mode"
SWITCHING=0
