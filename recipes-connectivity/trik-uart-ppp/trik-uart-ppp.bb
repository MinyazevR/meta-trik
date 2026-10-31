DESCRIPTION = "TCP/IP over UART using PPP"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=89aea4e17d99a7cacdbeed46a0096b10"

PV = "1.0"
PR = "r1"

inherit systemd features_check

REQUIRED_DISTRO_FEATURES = "systemd"

SYSTEMD_SERVICE:${PN} = "trik-uart-ppp.service"

RDEPENDS:${PN} += "base-files bash ppp util-linux-agetty shadow-base"

SRC_URI = " \
         file://init_ttyS1.sh \
         file://winclient.chat \
         file://ttyS1 \
         file://autologin \
         file://trik-uart-ppp.service \
"

do_install() {
	install -m 0755 -D -t ${D}${sysconfdir}/trik/ ${WORKDIR}/autologin
	install -m 0755 -D -t ${D}${sysconfdir}/trik/ ${WORKDIR}/init_ttyS1.sh
	install -m 0644 -D -t ${D}${sysconfdir}/ppp ${WORKDIR}/winclient.chat
	install -m 0644 -D -t ${D}${sysconfdir}/default ${WORKDIR}/ttyS1
	install -D -m 0644 ${WORKDIR}/trik-uart-ppp.service \
		${D}${systemd_system_unitdir}/trik-uart-ppp.service
}

FILES:${PN} += " \
    ${sysconfdir}/trik/autologin \
    ${sysconfdir}/trik/init_ttyS1.sh \
    ${sysconfdir}/ppp/winclient.chat \
    ${sysconfdir}/default/ttyS1 \
    ${systemd_system_unitdir}/trik-uart-ppp.service \
"

CONFFILES:${PN} += "${sysconfdir}/default/ttyS1 ${sysconfdir}/ppp/winclient.chat"
