#!/bin/sh
set -eu

# nRF52833 firmware update via MCUboot serial recovery + mcumgr-client.
#
# Flow:
#   1. read the running application version over USB (nrf-version);
#   2. compare it with firmware.version shipped in the image;
#   3. if they differ, hold BOOT low and pulse nReset to enter MCUboot
#      serial recovery, wait for the CDC-ACM port and upload the signed image.
#
# nRF52833 control lines on RK3568 GPIO bank 0:
#   BOOT  = GPIO0_C4 = line 20
#   RESET = GPIO0_B3 = line 11
BOOT_LINE="20"
RESET_LINE="11"

# The /dev/gpiochipN number is dynamic, so resolve bank 0 by its label.
GPIO_CHIP=""
for chip in /sys/bus/gpio/devices/*; do
	if [ "$(cat "$chip/label" 2>/dev/null)" = "gpio0" ]; then
		GPIO_CHIP=$(basename "$chip")
		break
	fi
done
if [ -z "$GPIO_CHIP" ]; then
	echo "nrf-fw-update: gpio0 chip not found" >&2
	exit 1
fi

BOOTLOADER_PORT="/dev/nrf52833-bl"
FW_DIR="/usr/libexec/trik/nrf52833"
FW_FILE="${FW_DIR}/trik-nrf52833.bin"
VERSION_FILE="${FW_DIR}/firmware.version"

RESET_PID=""
BOOT_PID=""

MCUMGR="mcumgr-client"
MCUMGR_OPTS="-d ${BOOTLOADER_PORT}"

log() {
	echo "nrf-fw-update: $*"
}

log_err() {
	echo "nrf-fw-update: $*" >&2
}

gpio_hold() {
	gpioset -c "$1" "$2=$3" >/dev/null 2>&1 &
	pid=$!
	sleep 0.2
	# gpioset (libgpiod v2) keeps running to hold the line; if it exited
	# immediately, the chip/line is wrong or busy — fail loudly instead of
	# proceeding with an un-held pin.
	if ! kill -0 "$pid" 2>/dev/null; then
		log_err "gpioset failed on $1 $2=$3"
		return 1
	fi
	echo "$pid"
}

# Release a line previously held by gpio_hold().
gpio_drop() {
	[ -n "${1:-}" ] || return 0
	kill "$1" 2>/dev/null || true
	wait "$1" 2>/dev/null || true
}

# Set a line to a value and release it immediately (used to pulse a signal).
gpio_set_output() {
	chip=$1 line=$2 val=$3
	gpioset -c "$chip" "$line=$val" >/dev/null 2>&1 &
	pid=$!
	sleep 0.2
	kill "$pid" 2>/dev/null || true
	wait "$pid" 2>/dev/null || true
}

# Return a line to its idle high level.
gpio_restore_high() {
	chip=$1 line=$2
	gpio_set_output "$chip" "$line" 1
}

# Always release held lines and restore idle levels, even on failure.
cleanup() {
	gpio_drop "$RESET_PID"
	gpio_drop "$BOOT_PID"
	gpio_restore_high "$GPIO_CHIP" "$BOOT_LINE"
	gpio_restore_high "$GPIO_CHIP" "$RESET_LINE"
}
trap cleanup EXIT

# Fail early if any required userspace tool is missing.
preflight() {
	for tool in ${MCUMGR} nrf-version gpioset; do
		command -v "$tool" >/dev/null 2>&1 || {
			log_err "required tool '$tool' not found"
			exit 1
		}
	done
}

# Enter MCUboot serial recovery: BOOT low selects recovery mode, the nReset
# pulse reboots the chip into the bootloader. Both lines are restored after.
reset_to_bootloader() {
	log "forcing device into bootloader (BOOT=0, RESET pulse)"
	BOOT_PID=$(gpio_hold "$GPIO_CHIP" "$BOOT_LINE" 0)
	RESET_PID=$(gpio_hold "$GPIO_CHIP" "$RESET_LINE" 0)
	sleep 0.01
	gpio_drop "$RESET_PID"
	RESET_PID=""
	# nRF must exit reset now — restore RESET to 1 immediately
	gpio_restore_high "$GPIO_CHIP" "$RESET_LINE"
	sleep 1
	gpio_drop "$BOOT_PID"
	BOOT_PID=""
	# nRF is already running bootloader — restore BOOT to 1
	gpio_restore_high "$GPIO_CHIP" "$BOOT_LINE"
	sleep 1
}

# Wait for the bootloader CDC-ACM port to appear after the reset.
wait_for_port() {
	port=$1
	i=0
	log "waiting for bootloader port $port"
	while [ "$i" -lt 10 ]; do
		if [ -c "$port" ]; then
			log "bootloader port $port detected"
			return 0
		fi
		sleep 1
		i=$((i + 1))
	done
	log_err "$port not available"
	return 1
}

# strip trailing whitespace/CR so a mismatch never comes from file formatting
norm() {
	printf '%s' "$1" | sed 's/[[:space:]]*$//'
}

# Read the running application version over USB. Retry while USB enumerates.
read_device_version() {
	device_version=""
	i=0
	while [ "$i" -lt 10 ]; do
		i=$((i + 1))
		log "reading device version via nrf-version (attempt $i/10)"
		if ver=$(nrf-version 2>&1); then
			device_version=$(norm "$(printf '%s\n' "$ver" | tail -n 1)")
			log "current version on device = ${device_version:-<empty>}"
			return 0
		fi
		diag=$(printf '%s\n' "$ver" | tail -n 1)
		log "  version query failed: ${diag}"
		sleep 1
	done
	log_err "could not read device version after 10 attempts"
	return 1
}

# Read the firmware version shipped with the image.
read_target_version() {
	target_version=$(norm "$(cat "$VERSION_FILE" 2>/dev/null || true)")
	log "required version (target) = ${target_version:-<empty>} (from $VERSION_FILE)"
}

# Upload the signed image and reset the device into the new application.
upload() {
	fw="$FW_FILE"
	[ -f "$fw" ] || { log_err "firmware image $fw not found"; return 1; }

	size=$(wc -c < "$fw")
	log "uploading $fw ($size bytes)"
	if ! ${MCUMGR} ${MCUMGR_OPTS} upload "$fw"; then
		log_err "firmware upload failed"
		return 1
	fi
	log "upload done, resetting device"
	${MCUMGR} ${MCUMGR_OPTS} reset
}

# Main entry point: compare versions and flash only when needed.
main() {
	preflight

	log "starting nRF52833 firmware check/update"
	read_device_version || true
	read_target_version

	if [ -z "$target_version" ]; then
		log_err "no target version in ${VERSION_FILE}"
		return 1
	fi

	if [ -n "$device_version" ] && [ "$device_version" = "$target_version" ]; then
		log "device is up to date (${device_version}), nothing to do"
		return 0
	fi

	if [ -n "$device_version" ]; then
		log "versions differ (device=$device_version, target=$target_version) — updating firmware"
	else
		log "no version reported by device — flashing fresh"
	fi

	reset_to_bootloader
	wait_for_port "$BOOTLOADER_PORT"
	upload
}

main
