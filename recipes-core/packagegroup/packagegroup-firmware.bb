SUMMARY = "Firmware package"
DESCRIPTION = "Firmware and update tools for RK3568 board and peripherals"
LICENSE = "LGPL-2.0-only"
PR = "r2"

PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit packagegroup

RDEPENDS:${PN} = "\
  nrf52833-fw \
  mcumgr-client \
  linux-firmware-wilc1000 \
  linux-firmware-rtl8188 \
  linux-firmware-rtl8822 \
"
