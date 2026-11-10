# look for files in the layer first
FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " \
               file://wlan.rules \
               file://wlan-rename.sh \
               file://video.rules \
               file://nrf-usb.rules \
               "

RDEPENDS:${PN} += "iproute2"

do_install:append() {
      install -m 0644 ${WORKDIR}/wlan.rules ${D}${sysconfdir}/udev/rules.d/
      install -D -m 0755 ${WORKDIR}/wlan-rename.sh ${D}${sysconfdir}/udev/scripts/wlan-rename.sh
      install -m 0644 ${WORKDIR}/video.rules ${D}${sysconfdir}/udev/rules.d/
      install -m 0644 ${WORKDIR}/nrf-usb.rules ${D}${sysconfdir}/udev/rules.d/
}
