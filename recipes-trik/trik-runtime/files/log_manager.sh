#!/bin/bash
# Script uses awk

set -euo pipefail

export LC_ALL=C 
export LANG=en_US.UTF-8

# log_file -- file where all outputs from this script execution are kept
log_file="/var/log/system_report.log"

# Output from script execution is redirected to log_file.
# If you want to print something to stdout use "special_echo" function.
exec 3>&1
special_echo() {
	echo "$1" >&3
}
exec &>> $log_file

archive_path="/var/trik/log"
remaining_size_limit_k=100


tree_elements_list=(
	"/home/root/trik/scripts/"
	"/home/root/trik/trik.log"
	"/var/log/"
	"/home/root/trik/model-config.xml"
	"/home/root/trik/system-config.xml"
	"/www/logs/"
	)
utils_list=(
	"cat /etc/version"
	"dmesg"
	"journalctl -b --no-pager"
	"i2cdetect -y 1"
	"i2cdetect -y 2"
	"i2cget -y 2 0x48 0xee w"
	"ifconfig"
	"lshw"
	"lsmod"
	"lsof"
	"lsusb -v"
	"ps ax"
	"uname -a"
	"v4l2-ctl -d /dev/video2 --all"
	"xinput list"
	)


tree_dir_name="tree"
utils_dir_name="utils"


replace_slashes() {
	echo "${1////_}"
}


# Estimate remaining size on the current partition
estimate_remaining_size() {
	echo "$(df . | awk '$4 ~ /[0-9]+/ { print $4 }')"
}

# Generate unique name for current controller, based on MAC address
generate_unique_name() {
	echo "trik$(cat /sys/class/net/wlan0/address | tail -c 9 | sed 's/://g')"
}

# Count files in log folder without duplicates, because at the moment of compression there are two files with one mask: "name" and "name.tar.gz"
count_without_duplicates() {
	echo "$(find ${archive_path} -maxdepth 1 -name "${1}-*" -print0 | xargs -0 -r -n 1 | cut -d . -f 1 | sort -u | wc -l)"
}

# Prepare directory where current core and snapshot of the system (logs and utilities outputs will be saved)
# $1: "true" -- if script was called by trikGui, "false" -- was called from outside (--all option)
prepare_tmp_dir() {
	mkdir -p "${archive_path}/"
	if [ "$1" = "true" ]; then
		rmdir --ignore-fail-on-non-empty ${archive_path}/* || true
	fi

	local name
	name=$(generate_unique_name)
	local version
	version=$(cat "/etc/version")
	local prefix
	prefix="${name}-${version}"
	local next_log_number
	next_log_number=$(count_without_duplicates "$prefix")
 
	local tmp_dir_name
	tmp_dir_name="${prefix}-$(printf "%02d" ${next_log_number})"
	local tmp_dir_path
	tmp_dir_path="${archive_path}/${tmp_dir_name}"

	mkdir -p "$tmp_dir_path"
	
	echo "${tmp_dir_path}"
}


collect_tree() {
	for tree_element in "${tree_elements_list[@]}"; do
		echo "$tree_element"
		cp -rvL "$tree_element" "${1}/${tree_dir_name}/$(replace_slashes "$tree_element")" || true
	done
}


redirect_command() {
	$1
} > "$2/${utils_dir_name}/$(replace_slashes "$1")"


collect_utils() {
	for util in "${utils_list[@]}"; do
		echo "$util"
		redirect_command "$util" "$1" || echo " FAILED"
	done
}


clean_up() {
	rm -f "/home/root/trik/trik.log"
	rm -f "/home/root/trik/scripts/core"
}


# Collect info about current system state (logs and utilities output)
# $1 -- path to directory where they should be saved
collect() {
	if [ "$(estimate_remaining_size)" -gt "${remaining_size_limit_k}" ]; then 	
		mkdir -p $1/{${tree_dir_name},${utils_dir_name}}
		collect_tree "$1"
		collect_utils "$1"
		clean_up
		sync
	fi
}


# Compress a single collected directory into a .tar.gz and remove the directory
compress_one() {
	local d="$1"
	if [ ! -d "$d" ]; then
		return 0
	fi
	if [ -z "$(ls -A "$d" 2>/dev/null)" ]; then
		return 0
	fi
	tar czf "${d}.tar.gz" -C "$d" . 2>/dev/null || true
	rm -rf "$d" 2>/dev/null || true
}


# Compress leftover directories in the log folder
compress() {
	if ! mkdir "${archive_path}/.lock" 2>/dev/null; then
		return 0
	fi

	local d
	while IFS= read -r -d '' d; do
		compress_one "$d"
	done < <(find "${archive_path}" -mindepth 1 -maxdepth 1 -type d -print0 2>/dev/null)

	rmdir "${archive_path}/.lock" 2>/dev/null || true
}


main() {
	if [ "$1" = "--create" ]; then 
		tmp_dir=$(prepare_tmp_dir "true")
		special_echo "${tmp_dir}"
	elif [ "$1" = "--collect" ]; then
		collect "$2"
	elif [ "$1" = "--gc" ]; then
		compress
	elif [ "$1" = "--all" ]; then
		local tmp_dir
		tmp_dir=$(prepare_tmp_dir "false")
		collect "$tmp_dir"
		compress_one "$tmp_dir"
		special_echo "${tmp_dir}"
	else 
		echo "No such command"
	fi
}


command=${1:-}
option=${2:-}
echo "$option"
main "$command" "$option"
