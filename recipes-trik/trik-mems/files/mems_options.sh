#!/bin/sh

# NOTE: written by trik-webpanel (www/cgi-bin/ag-config.sh).
# Legacy MMA845X/L3GD42XXD options; needs rework for the ICM-42670-P /
# IIO attributes on RK3568. init_mems.sh no longer reads this file.

# a_state: true - enabled, false - disabled
# a_freq: 0 - 800, 1 - 400, 2 - 200, 3 - 100, 4 - 50, 5 - 12_5, 6 - 6_25, 7 - 1_56  (MMA845X_ODR_800)
# a_range: 0 - 2G, 1 - 4G, 2 - 8G (MMA845X_FS_2G)
# g_state: true - enabled, false - disabled 
# g_freq: 0 - 95, 1 - 190, 2 - 380, 3 - 760 (L3GD42XXD_ODR_95)
# g_range: 0 - 250, 1 - 500, 2 - 2000 (L3GD42XXD_FS_250)

accel_state=true
accel_freq=5
accel_range=0
gyro_state=true
gyro_freq=1
gyro_range=0
