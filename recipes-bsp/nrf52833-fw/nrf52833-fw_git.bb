SUMMARY = "nRF52833 firmware update via MCUboot + mcumgr"
DESCRIPTION = "Firmware update pipeline for nRF52833 coprocessor using MCUboot SMP protocol"
# NOTE: architecturally this firmware update path belongs in the kernel as a
# custom nrf-usb driver, with the firmware installed under the standard
# /lib/firmware path. The current userspace pipeline is an interim workaround.
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://git/LICENSE;md5=e23fadd6ceef8c618fc1c65191d846fa"

COMPATIBLE_MACHINE = "trikboard"

SRC_URI = " \
    git://github.com/trikset/trik-nrf52833.git;protocol=https;branch=main \
    file://update_nrf_fw.sh \
    file://nrf-fw-update.service \
    file://99-nrf52833.rules \
    file://nrf-version.c \
"

SRCREV = "${AUTOREV}"

# Signed image path inside the repo checkout.
NRF_FW_BIN ?= "bin/trik-nrf52833.bin"
# Target firmware version marker, kept in sync with the binary in the repo.
NRF_FW_VERSION ?= "firmware.version"

DEPENDS = "nrf-usb-headers"

RDEPENDS:${PN} = "mcumgr-client coreutils libgpiod-tools"

S = "${WORKDIR}"
B = "${WORKDIR}/build"

inherit systemd

SYSTEMD_SERVICE:${PN} = "nrf-fw-update.service"

do_compile() {
    install -d ${B}
    ${CC} ${CFLAGS} ${LDFLAGS} ${S}/nrf-version.c -o ${B}/nrf-version
}

do_install() {
    install -d ${D}${libexecdir}/trik/nrf52833
    install -m 0755 ${S}/update_nrf_fw.sh  ${D}${libexecdir}/trik/nrf52833/
    install -m 0644 ${S}/git/${NRF_FW_BIN} ${D}${libexecdir}/trik/nrf52833/trik-nrf52833.bin
    install -m 0644 ${S}/git/${NRF_FW_VERSION} ${D}${libexecdir}/trik/nrf52833/firmware.version

    install -d ${D}${bindir}
    install -m 0755 ${B}/nrf-version       ${D}${bindir}/nrf-version

    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${S}/nrf-fw-update.service ${D}${systemd_system_unitdir}/

    install -d ${D}${sysconfdir}/udev/rules.d
    install -m 0644 ${S}/99-nrf52833.rules ${D}${sysconfdir}/udev/rules.d/
}

FILES:${PN} += "${libexecdir}/trik/nrf52833 ${sysconfdir}/udev/rules.d"
