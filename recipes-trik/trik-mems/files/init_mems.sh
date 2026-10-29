#!/bin/bash
# TODO: revisit for the new RK3568 sensors (legacy: iio:device0/device1).
exit 0

set -ueo pipefail
[ -r /etc/default/trik/mems_options.sh ] && source /etc/default/trik/mems_options.sh || :

readonly ACCEL=iio:device0
readonly GYRO=iio:device1

set_up_accel() {
        echo "$1" > /sys/bus/iio/devices/"$ACCEL"/scan_elements/in_timestamp_en
        echo "$1" > /sys/bus/iio/devices/"$ACCEL"/scan_elements/in_accel_x_en
        echo "$1" > /sys/bus/iio/devices/"$ACCEL"/scan_elements/in_accel_y_en
        echo "$1" > /sys/bus/iio/devices/"$ACCEL"/scan_elements/in_accel_z_en
}

set_up_gyro() {
        echo "$1" > /sys/bus/iio/devices/"$GYRO"/scan_elements/in_timestamp_en
        echo "$1" > /sys/bus/iio/devices/"$GYRO"/scan_elements/in_anglvel_x_en
        echo "$1" > /sys/bus/iio/devices/"$GYRO"/scan_elements/in_anglvel_y_en
        echo "$1" > /sys/bus/iio/devices/"$GYRO"/scan_elements/in_anglvel_z_en
}

enable_device() {
        echo "$1" > /sys/bus/iio/devices/"$2"/buffer/enable
}

main() {
        set_up_accel 1
        set_up_gyro 1

        enable_device 1 "$ACCEL"
        enable_device 1 "$GYRO"
}

main
