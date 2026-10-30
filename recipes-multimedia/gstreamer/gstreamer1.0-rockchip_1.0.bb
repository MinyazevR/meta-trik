SUMMARY = "GStreamer Rockchip MPP plugins"
DESCRIPTION = "GStreamer plugins for Rockchip MPP hardware codec blocks"
HOMEPAGE = "https://github.com/trikset/trik-rockchip-bsp-mirrors"
SECTION = "multimedia"
LICENSE = "LGPL-2.0-only"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/LGPL-2.0-only;md5=9427b8ccf5cf3df47c29110424c9641a"

SRC_URI = "git://github.com/trikset/trik-rockchip-bsp-mirrors.git;protocol=https;branch=trik-gstreamer-rockchip"
SRCREV = "c489081e4ca927fa8c1d1c438559b8cff84a66dc"

S = "${WORKDIR}/git"

DEPENDS = " \
    rockchip-mpp \
    librga \
    libdrm \
    virtual/egl \
    virtual/libgles2 \
    virtual/libgbm \
    gstreamer1.0 \
    gstreamer1.0-plugins-base \
"

inherit meson pkgconfig

EXTRA_OEMESON += " \
    -Drockchipmpp=enabled \
    -Dkmssrc=disabled \
    -Drkximage=disabled \
    -Drga=enabled \
    -Dgpu=enabled \
    -Dvpxalphadec=enabled \
"

FILES:${PN} += "${libdir}/gstreamer-1.0/*.so"