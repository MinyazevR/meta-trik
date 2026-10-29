SUMMARY = "Wifi tools"
DESCRIPTION = "The minimal set of packages required to manupulate wifi"
LICENSE = "LGPL-2.0-only"
PR = "r1"

PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit packagegroup


MACHINE_ESSENTIAL_EXTRA_RDEPENDS ?= ""
MACHINE_ESSENTIAL_EXTRA_RRECOMMENDS ?= ""


RDEPENDS:${PN} = "\
  netcat-openbsd \
  wpa-supplicant \
  packagegroup-base-wifi \
  hostapd \
  trik-webpanel \
  tcpdump \
  ${MACHINE_ESSENTIAL_EXTRA_RDEPENDS} \
 "

RRECOMMENDS:${PN} = "\
  ${MACHINE_ESSENTIAL_EXTRA_RRECOMMENDS} \
 "

