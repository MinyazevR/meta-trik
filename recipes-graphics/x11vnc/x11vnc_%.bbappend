FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI += " file://x11vnc.service \
             file://x11vnc-start.sh \
"

inherit systemd

SYSTEMD_SERVICE:${PN} = "x11vnc.service"
SYSTEMD_AUTO_ENABLE:${PN} = "enable"

do_install:append() {
	install -d ${D}${libexecdir}/trik
	install -m 0755 ${WORKDIR}/x11vnc-start.sh ${D}${libexecdir}/trik/x11vnc-start.sh

	install -d ${D}${systemd_system_unitdir}
	install -m 0644 ${WORKDIR}/x11vnc.service ${D}${systemd_system_unitdir}/
}

FILES:${PN} += "${libexecdir}/trik/x11vnc-start.sh \
                ${systemd_system_unitdir}/x11vnc.service \
"
