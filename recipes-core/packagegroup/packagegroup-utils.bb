SUMMARY = "Utils"
DESCRIPTION = "The minimal set of packages required to manupulate usb, i2c,input devices,ext2FS"
LICENSE = "LGPL-2.0-only"
PR = "r1"

PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit packagegroup


MACHINE_ESSENTIAL_EXTRA_RDEPENDS ?= ""
MACHINE_ESSENTIAL_EXTRA_RRECOMMENDS ?= ""

RDEPENDS:${PN} = "\
  iptables \
  mtd-utils \
  evtest \
  devmem2 \
  i2c-tools \
  usbutils \
  e2fsprogs \
  mc \
  lrzsz \
  ntp \
  strace \
  ltrace \
  cronie \
  tzdata \
  rsync \
  fbgrab \
  curl \
  psplash \
  picocom \
  usb-modeswitch \
  usb-modeswitch-data \
  rp-pppoe \
  samba \
  winbind \
  openvpn \
  can-utils \
  iproute2 \
  iftop \
  iotop \
  dool \
  fbgrab \
  fim \
  psmisc \
  ldd \
  fb-test \
  nano \
  ${MACHINE_ESSENTIAL_EXTRA_RDEPENDS} \
  dbus-dev \
"
#  lshw

RRECOMMENDS:${PN} = "\
  ${MACHINE_ESSENTIAL_EXTRA_RRECOMMENDS} \
 "

