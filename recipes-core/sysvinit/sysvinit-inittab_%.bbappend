FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

do_install:append() {
	echo "tg:5:respawn:/etc/trik/trikGui.sh" >> ${D}${sysconfdir}/inittab
	echo "gs:5:respawn:/etc/trik/current-gamepad-service" >> ${D}${sysconfdir}/inittab
}

