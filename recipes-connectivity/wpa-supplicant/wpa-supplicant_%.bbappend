FILESEXTRAPATHS:prepend := "${THISDIR}/${BPN}:"

SRC_URI:append = " file://wpa_supplicant@.service \
                   file://wpa_supplicant.conf.trik \
"

# Override the OE template: no device Requires/After and no [Install].
# udev starts instances on demand, which avoids boot hangs from stale wlan0.
do_install:append() {
	install -d ${D}${sysconfdir}/systemd/system
	install -m 0644 ${WORKDIR}/wpa_supplicant@.service \
		${D}${sysconfdir}/systemd/system/wpa_supplicant@.service

	# Do not ship the OE "sane" config with an open wildcard network.
	# Otherwise wpa_supplicant auto-connects to any open AP.
	install -m 600 ${WORKDIR}/wpa_supplicant.conf.trik ${D}${sysconfdir}/wpa_supplicant.conf
}

CONFFILES:${PN} += "${sysconfdir}/systemd/system/wpa_supplicant@.service"
