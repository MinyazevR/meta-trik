FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://trik-smb.conf"

do_install:append() {
	install -m 0644 ${WORKDIR}/trik-smb.conf ${D}${sysconfdir}/samba/smb.conf
}
