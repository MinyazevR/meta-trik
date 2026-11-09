SECTION = "kernel"
SUMMARY = "Linux kernel for TRIK (Rockchip RK3568)"
DESCRIPTION = "Rockchip BSP 6.12 kernel for the TRIK controller (RK3568)"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://COPYING;beginline=1;endline=355;md5=6bc538ed5bd9a7fc9398086aedcd7e46"

inherit kernel

SRC_URI = " \
    git://github.com/trikset/trik-rockchip-linux.git;protocol=https;branch=trik \
    file://defconfig \
"
SRCREV = "${AUTOREV}"
LINUX_VERSION = "6.12.69"

S = "${WORKDIR}/git"
