SUMMARY = "GStreamer Rockchip MPP plugins"
DESCRIPTION = "GStreamer plugins for Rockchip MPP hardware codec blocks"
HOMEPAGE = "https://github.com/trikset/trik-rockchip-bsp-mirrors"
SECTION = "multimedia"
LICENSE = "LGPL-2.0-only"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/LGPL-2.0-only;md5=9427b8ccf5cf3df47c29110424c9641a"

SRC_URI = "https://github.com/trikset/trik-rockchip-bsp-mirrors/archive/c489081e4ca927fa8c1d1c438559b8cff84a66dc.tar.gz"
SRC_URI[sha256sum] = "57815420a8b16ca4dc06b8642c0ef409ff54598290bb4a79c810110393b31dd3"

S = "${WORKDIR}/trik-rockchip-bsp-mirrors-c489081e4ca927fa8c1d1c438559b8cff84a66dc"

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
INSANE_SKIP:${PN} += "src-uri-bad"
