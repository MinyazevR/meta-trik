FILESEXTRAPATHS:prepend := "${THISDIR}/${BPN}:"

SRC_URI += "file://trik.conf"

do_install:append() {
    install -d ${D}${sysconfdir}/systemd/system/hostapd.service.d
    install -m 0644 ${WORKDIR}/trik.conf ${D}${sysconfdir}/systemd/system/hostapd.service.d/trik.conf
}

FILES:${PN} += "${sysconfdir}/systemd/system/hostapd.service.d"
