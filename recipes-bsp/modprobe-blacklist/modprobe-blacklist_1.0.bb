SUMMARY = "Kernel module blacklist configuration"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "file://blacklist.conf"

do_install() {
	install -d ${D}${sysconfdir}/modprobe.d
	install -m 0644 ${WORKDIR}/blacklist.conf ${D}${sysconfdir}/modprobe.d/blacklist.conf
}

FILES:${PN} = "${sysconfdir}/modprobe.d/blacklist.conf"
