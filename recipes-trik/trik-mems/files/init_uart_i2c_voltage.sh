#!/bin/bash
# TODO: legacy OMAP GPIO (/sys/class/gpio/gpio30); revisit for RK3568.
exit 0

[ -r /etc/default/trik/uart_i2c_voltage_options.sh ] && source /etc/default/trik/uart_i2c_voltage_options.sh || :

enable_3v() {
        echo low > /sys/class/gpio/gpio30/direction
        echo 0 > /sys/class/gpio/gpio30/value
}

enable_5v() {
        echo high > /sys/class/gpio/gpio30/direction
        echo 1 > /sys/class/gpio/gpio30/value
}


main() {
        echo 30 > /sys/class/gpio/export

        if [[ "$ENABLE_5V" == 1 ]]; then
                enable_5v
        else
                enable_3v
        fi
}

main
