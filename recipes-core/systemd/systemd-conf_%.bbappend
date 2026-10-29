FILESEXTRAPATHS:prepend := "${THISDIR}/${BPN}:"

SRC_URI += "file://50-trik.preset"

do_install:append() {
    install -d ${D}${systemd_unitdir}/system-preset
    install -m 0644 ${WORKDIR}/50-trik.preset ${D}${systemd_unitdir}/system-preset/50-trik.preset
}

FILES:${PN} += "${systemd_unitdir}/system-preset/50-trik.preset"
