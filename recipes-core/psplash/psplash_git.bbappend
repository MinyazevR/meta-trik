FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI += " file://0001-psplash-Add-Arago-custom-color.patch \
             file://psplash-start-rotation.conf \
"
SPLASH_IMAGES = "file://psplash-trik.png;outsuffix=default"

FILES:${PN} += "/mnt/.psplash \
                ${sysconfdir}/systemd/system/psplash-start.service.d \
"

CONFFILES:${PN} += "${sysconfdir}/systemd/system/psplash-start.service.d/rotation.conf"

do_install:append() {
        install -d ${D}/mnt/.psplash/
        install -d ${D}${sysconfdir}/systemd/system/psplash-start.service.d
        install -m 0644 ${WORKDIR}/psplash-start-rotation.conf \
                ${D}${sysconfdir}/systemd/system/psplash-start.service.d/rotation.conf
}
