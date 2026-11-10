DESCRIPTION = "TRIK MEMS init scripts"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=89aea4e17d99a7cacdbeed46a0096b10"

RDEPENDS:${PN} += "bash"

SRC_URI = "file://init_mems.sh \
           file://mems_options.sh \
           file://trik-mems.service"

inherit systemd

SYSTEMD_SERVICE:${PN} = "trik-mems.service"

do_install() {
	install -d ${D}${libexecdir}/trik ${D}${sysconfdir}/default/trik ${D}${systemd_system_unitdir}
	install -m 0755 ${WORKDIR}/init_mems.sh ${D}${libexecdir}/trik/
	install -m 0755 ${WORKDIR}/mems_options.sh ${D}${sysconfdir}/default/trik/
	install -m 0644 ${WORKDIR}/trik-mems.service ${D}${systemd_system_unitdir}/
}

FILES:${PN} += "${libexecdir}/trik ${sysconfdir}/default/trik ${systemd_system_unitdir}"
