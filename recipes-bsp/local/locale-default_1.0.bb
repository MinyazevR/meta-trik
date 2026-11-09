SUMMARY = "Install default locale for system"
DESCRIPTION		= ""
LICENSE			= "MIT"
LIC_FILES_CHKSUM	= "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"
SRC_URI			= "file://locale.sh file://locale.conf"
do_install () {
	install -m 755 -d ${D}${sysconfdir}/profile.d/
	install -m 644 ${WORKDIR}/locale.sh ${D}${sysconfdir}/profile.d/
	install -m 644 ${WORKDIR}/locale.conf ${D}${sysconfdir}/locale.conf
}

