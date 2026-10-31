SUMMARY = "Rockchip RGA userspace library"
DESCRIPTION = "Userspace library and im2d API for the Rockchip RGA 2D accelerator"
HOMEPAGE = "https://github.com/airockchip/librga"
SECTION = "multimedia"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://COPYING;md5=89aea4e17d99a7cacdbeed46a0096b10"

SRC_URI = "https://github.com/trikset/trik-rockchip-bsp-mirrors/archive/57a1067a246c71fa6c9a355d1668884fda155dd5.tar.gz"
SRC_URI[sha256sum] = "254d36553cb1119c64f9fb173ca18451c22deb0643f48de74a8b62dbdd1bd965"

S = "${WORKDIR}/trik-rockchip-bsp-mirrors-57a1067a246c71fa6c9a355d1668884fda155dd5"

inherit meson pkgconfig

EXTRA_OEMESON += " \
    -Dlibrga_demo=false \
"

INSANE_SKIP:${PN} += "src-uri-bad"
