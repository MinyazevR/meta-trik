SUMMARY = "MediaMTX real-time media server"
DESCRIPTION = "Zero-dependency live media server and media proxy for RTSP, WebRTC, HLS, RTMP and SRT"
HOMEPAGE = "https://github.com/bluenviron/mediamtx"
SECTION = "multimedia"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://LICENSE;md5=77fd2623bd5398430be5ce60489c2e81"

PV = "1.9.3"
PR = "r1"

SRC_URI = " \
    https://github.com/bluenviron/mediamtx/releases/download/v${PV}/mediamtx_v${PV}_linux_arm64v8.tar.gz \
    file://mediamtx-trik.yml \
    file://mediamtx.service \
"
SRC_URI[sha256sum] = "f2f02109dd3d88773d7de5ae84385d41041bc9d60d0459eb6c61462cb2da0d1e"

S = "${WORKDIR}"

COMPATIBLE_HOST = "aarch64.*"

inherit systemd

do_configure[noexec] = "1"
do_compile[noexec] = "1"

do_install() {
    install -d ${D}${bindir}
    install -m 0755 ${S}/mediamtx ${D}${bindir}/mediamtx

    install -d ${D}${sysconfdir}/mediamtx
    install -m 0644 ${WORKDIR}/mediamtx-trik.yml ${D}${sysconfdir}/mediamtx/mediamtx.yml

    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/mediamtx.service ${D}${systemd_system_unitdir}/
}

FILES:${PN} += " \
    ${sysconfdir}/mediamtx \
    ${systemd_system_unitdir}/mediamtx.service \
"
CONFFILES:${PN} += "${sysconfdir}/mediamtx/mediamtx.yml"
SYSTEMD_SERVICE:${PN} = "mediamtx.service"
SYSTEMD_AUTO_ENABLE:${PN} = "enable"
