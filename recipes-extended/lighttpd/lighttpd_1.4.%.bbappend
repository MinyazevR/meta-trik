SUMMARY += "(TRIK edition)"

FILESEXTRAPATHS:prepend := "${THISDIR}/${BPN}:"

#until TRIK's own scrtips moved to separate package, we need bash
RDEPENDS:${PN} += "bash"

RDEPENDS:${PN} += " \
        lighttpd-module-cgi \
        lighttpd-module-proxy \
"

SRC_URI:append = "file://wpa-configurator.sh \
        file://wpa-writer.sh \
        file://wlan-scanner.sh \
        file://lock.png \
        file://wpa_base.css \
        file://wpa-configurator.js \
        file://wifi-configurator.html \
        file://wifi-configurator.css \
        file://admin.html \
        file://admin.css \
        file://handler.js \
        file://web.html \
        file://web.js \
        file://logo.png \
        file://montserrat.ttf \
"
do_install:append() {
    install -d ${D}/www/pages/network
    install -d ${D}/www/pages/images
    install -d ${D}/www/pages/styles
    install -d ${D}/www/pages/js
    install -d ${D}/www/pages/fonts
    install -m 0755 ${WORKDIR}/wpa-configurator.sh ${D}/www/pages/network/
    install -m 0755 ${WORKDIR}/wpa-writer.sh ${D}/www/pages/network/
    install -m 0755 ${WORKDIR}/wlan-scanner.sh ${D}/www/pages/network/
    install -m 0644 ${WORKDIR}/lock.png ${D}/www/pages/images/
    install -m 0644 ${WORKDIR}/wpa_base.css ${D}/www/pages/styles/
    install -m 0644 ${WORKDIR}/wpa-configurator.js ${D}/www/pages/js/
    install -m 0644 ${WORKDIR}/wifi-configurator.html ${D}/www/pages/
    install -m 0644 ${WORKDIR}/admin.html ${D}/www/pages/
    install -m 0644 ${WORKDIR}/wifi-configurator.css ${D}/www/pages/styles/
    install -m 0644 ${WORKDIR}/admin.css ${D}/www/pages/styles/
    install -m 0644 ${WORKDIR}/handler.js ${D}/www/pages/js/
    install -m 0644 ${WORKDIR}/web.html ${D}/www/pages/
    install -m 0644 ${WORKDIR}/logo.png ${D}/www/pages/images/
    install -m 0644 ${WORKDIR}/montserrat.ttf ${D}/www/pages/fonts/
    install -m 0644 ${WORKDIR}/web.js ${D}/www/pages/js/
}
