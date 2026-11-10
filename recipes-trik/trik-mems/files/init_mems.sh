#!/bin/bash

set -ueo pipefail

# ICM-42670-P is a single IIO device exposing accel, gyro and timestamp.
# Find it by the DTS label (label = "trik-imu";) so the lookup is stable.
IMU_LABEL="trik-imu"
IMU_DEV=""
for label in /sys/bus/iio/devices/iio:device*/label; do
        [ -r "$label" ] || continue
        if [ "$(cat "$label")" = "$IMU_LABEL" ]; then
                IMU_DEV="$(dirname "$label")"
                break
        fi
done

if [ -z "$IMU_DEV" ]; then
        echo "init_mems: ICM-42670-P IIO device not found" >&2
        exit 1
fi

enable_imu_buffer() {
        for ch in in_accel_x_en in_accel_y_en in_accel_z_en \
                  in_anglvel_x_en in_anglvel_y_en in_anglvel_z_en \
                  in_timestamp_en; do
                if [ -e "$IMU_DEV/scan_elements/$ch" ]; then
                        echo 1 > "$IMU_DEV/scan_elements/$ch"
                fi
        done
        echo 1 > "$IMU_DEV/buffer/enable"
}

enable_imu_buffer
