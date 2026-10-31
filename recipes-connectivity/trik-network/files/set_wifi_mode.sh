#!/bin/sh
# TRIK wifi mode switch: client (wpa_supplicant + networkd DHCP) | ap (hostapd + networkd DHCPServer)
set -eu

TRIKRC=/etc/trik/trikrc
HOSTAPD_CONF=/etc/hostapd.conf

IFACE="${1:-}"
mode="${2:-client}"

[ -n "$IFACE" ] || { echo "set_wifi_mode: no wireless interface" >&2; exit 1; }
[ -e "/sys/class/net/${IFACE}" ] || { echo "set_wifi_mode: ${IFACE} does not exist" >&2; exit 1; }

case "$mode" in
	client|ap) ;;
	*) echo "usage: $0 <iface> client|ap" >&2; exit 1 ;;
esac

mkdir -p "$(dirname "$TRIKRC")"
[ -f "$TRIKRC" ] || : > "$TRIKRC"
chmod 600 "$TRIKRC"

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

ap_passphrase() {
	p="$(trik_get trik_wifi_ap_passphrase)"
	[ "${#p}" -eq 8 ] || {
		p="$(tr -dc '0-9' </dev/urandom | head -c 8)"
		[ "${#p}" -eq 8 ] || p="00000000"
		trik_set trik_wifi_ap_passphrase "$p"
	}
	printf '%s' "$p"
}

generate_hostapd_conf() {
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
}

start_target() {
	systemctl start "trik-wifi-$1.target"
}

disable_power_save() {
	if ! command -v iw >/dev/null 2>&1; then
		return 0
	fi
	iw dev "$IFACE" set power_save off >/dev/null 2>&1 || \
		echo "set_wifi_mode: power save off not supported on $IFACE" >&2
}

SAVED_MODE="$(trik_get trik_wifi_mode)"
SWITCHING=0

rollback() {
	[ "$SWITCHING" = 1 ] || return 0
	SWITCHING=0
	echo "set_wifi_mode: restoring '${SAVED_MODE:-client}'" >&2
	start_target "${SAVED_MODE:-client}" || true
	trik_set trik_wifi_mode "${SAVED_MODE:-client}" || true
}

sigterm_handler() {
	trap '' SIGTERM SIGINT
	rollback
	exit 2
}

restore_on_exit() {
	rc=$?
	trap - EXIT
	[ "$rc" -eq 0 ] || rollback
}

trap restore_on_exit EXIT
trap sigterm_handler SIGTERM SIGINT

SWITCHING=1
trik_set trik_wifi_mode ""

if [ "$mode" = "ap" ]; then
	generate_hostapd_conf
fi

start_target "$mode"
if [ "$mode" = "client" ]; then
	disable_power_save
fi
trik_set trik_wifi_mode "$mode"
SWITCHING=0
