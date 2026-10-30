SUMMARY = "Rockchip RGA userspace library"
DESCRIPTION = "Userspace library and im2d API for the Rockchip RGA 2D accelerator"
HOMEPAGE = "https://github.com/airockchip/librga"
SECTION = "multimedia"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://COPYING;md5=89aea4e17d99a7cacdbeed46a0096b10"

SRC_URI = "git://github.com/JeffyCN/mirrors.git;protocol=https;branch=linux-rga-multi"
SRCREV = "57a1067a246c71fa6c9a355d1668884fda155dd5"

S = "${WORKDIR}/git"

inherit meson pkgconfig

EXTRA_OEMESON += " \
    -Dlibrga_demo=false \
"
