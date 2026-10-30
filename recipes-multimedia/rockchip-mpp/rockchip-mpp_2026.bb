SUMMARY = "Rockchip MPP userspace library"
DESCRIPTION = "Userspace library for Rockchip hardware codec blocks"
HOMEPAGE = "https://github.com/rockchip-linux/mpp"
SECTION = "multimedia"
LICENSE = "Apache-2.0 | MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

SRC_URI = "git://github.com/rockchip-linux/mpp.git;protocol=https;branch=develop"
SRCREV = "20959ec3dabb313b8c33ca0b7b09c06ffd2a9caa"

S = "${WORKDIR}/git"

DEPENDS = "libdrm"

inherit cmake pkgconfig

EXTRA_OECMAKE += " \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_LIBDIR=${libdir} \
    -DBUILD_SHARED_LIBS=ON \
    -DBUILD_TEST=ON \
"

FILES:${PN} += "${includedir}/rockchip/*.h"