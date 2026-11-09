PACKAGES =+ "${PN}-wilc1000"
FILES:${PN}-wilc1000 = "${nonarch_base_libdir}/firmware/atmel/wilc1000_*.bin"
LICENSE:${PN}-wilc1000 = "Firmware-atmel"
RDEPENDS:${PN}-wilc1000 += "${PN}-license"
