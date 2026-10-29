FILESEXTRAPATHS:prepend := "${THISDIR}/${BPN}:"
hostname = ""

COMPATIBLE_MACHINE = "trikboard"

SRC_URI += " \
    file://trik-hostname.sh \
    file://trik-hostname.service \
    file://trik-serial-number \
    file://issue \
    file://issue.net \
    file://fstab.trik \
    file://rotation \
"

inherit systemd

SYSTEMD_SERVICE:${PN} = "trik-hostname.service"

do_install:append() {
    install -m 0644 ${S}/issue      ${D}${sysconfdir}/issue
    install -m 0644 ${S}/issue.net  ${D}${sysconfdir}/issue.net
    install -m 0644 ${S}/fstab.trik ${D}${sysconfdir}/fstab

    install -m 0644 ${S}/rotation   ${D}${sysconfdir}/rotation

    install -d ${D}${libexecdir}/trik
    install -m 0755 ${S}/trik-hostname.sh   ${D}${libexecdir}/trik/
    install -m 0755 ${S}/trik-serial-number ${D}${libexecdir}/trik/

    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${S}/trik-hostname.service ${D}${systemd_system_unitdir}/
}

FILES:${PN} += " \
    ${libexecdir}/trik \
    ${sysconfdir}/rotation \
"
