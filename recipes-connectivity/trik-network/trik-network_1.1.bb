HOMEPAGE = "http://trikset.com"
SECTION = "kernel/userland"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=89aea4e17d99a7cacdbeed46a0096b10"
SUMMARY = "Shell scripts for managing WiFi on TRIK controller"

inherit systemd

SYSTEMD_SERVICE:${PN} = "trik-wifi-init@.service trik-wifi-init.service"

RDEPENDS:${PN} += "hostapd wpa-supplicant coreutils"

SRC_URI = " \
    file://set_wifi_mode.sh \
    file://trik-wifi-init.service \
    file://trik-wifi-init@.service \
    file://wifi-station.network \
    file://wifi-ap.network \
"

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
	ln -sf ${libexecdir}/trik/set_wifi_mode.sh ${D}${sysconfdir}/trik/set_wifi_mode.sh

	install -D -m 0644 -t ${D}${systemd_system_unitdir} \
		${S}/trik-wifi-init.service ${S}/trik-wifi-init@.service

	install -d ${D}${datadir}/trik/networkd
	install -m 0644 ${S}/wifi-station.network ${D}${datadir}/trik/networkd/
	install -m 0644 ${S}/wifi-ap.network ${D}${datadir}/trik/networkd/
}

FILES:${PN} += " \
    ${libexecdir}/trik/set_wifi_mode.sh \
    ${sysconfdir}/trik/set_wifi_mode.sh \
    ${systemd_system_unitdir}/trik-wifi-init.service \
    ${systemd_system_unitdir}/trik-wifi-init@.service \
    ${datadir}/trik/networkd \
"
