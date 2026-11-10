HOMEPAGE = "http://trikset.com"
SECTION = "kernel/userland"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=89aea4e17d99a7cacdbeed46a0096b10"
SUMMARY = "Shell scripts for managing WiFi on TRIK controller"

inherit systemd

SRC_URI="\
         file://set_wifi_mode.sh \
         file://set_wifi_config.sh \
         file://trik-wifi-mode@.service \
         file://trik-wifi-config@.service \
         file://trik-wifi-client.target \
         file://trik-wifi-ap.target \
         file://wifi-station.network \
         file://wifi-ap.network \
         "
RDEPENDS:${PN} += "hostapd wpa-supplicant coreutils iw"

FILES:${PN} += "${datadir}/trik ${libexecdir}/trik ${sysconfdir}/trik/set_wifi_mode.sh ${systemd_system_unitdir}"

S = "${WORKDIR}"

do_configure() {
   :
}
do_compile() {
	:
}
do_install() {
	install -d ${D}${libexecdir}/trik ${D}${sysconfdir}/trik
	install -m 0755 ${S}/set_wifi_mode.sh ${D}${libexecdir}/trik/set_wifi_mode.sh
	install -m 0755 ${S}/set_wifi_config.sh ${D}${libexecdir}/trik/set_wifi_config.sh
	ln -sf ${libexecdir}/trik/set_wifi_mode.sh ${D}${sysconfdir}/trik/set_wifi_mode.sh

	install -D -m 0644 -t ${D}${systemd_system_unitdir} \
		${S}/trik-wifi-mode@.service \
		${S}/trik-wifi-config@.service \
		${S}/trik-wifi-client.target \
		${S}/trik-wifi-ap.target

	install -d ${D}${datadir}/trik/networkd
	install -m 0644 ${S}/wifi-station.network ${D}${datadir}/trik/networkd/
	install -m 0644 ${S}/wifi-ap.network ${D}${datadir}/trik/networkd/
}
