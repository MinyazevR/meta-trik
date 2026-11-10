FILESEXTRAPATHS:prepend := "${THISDIR}/${BPN}:"
hostname = ""

COMPATIBLE_MACHINE = "trikboard"

SRC_URI += " \
    file://init-trik \
    file://trik-hostname.sh \
    file://trik-hostname.service \
    file://trik-serial-number \
    file://issue \
    file://issue.net \
    file://fstab.trik \
    file://rotation \
"

inherit update-rc.d systemd

# Keep the generic init.d runner until the remaining snippets (log GC) are
# converted to systemd units; remove it together with trik-runtime-systemd.
# The systemd class otherwise wipes /etc/init.d when a package ships a unit.
RMINITDIR:class-target = ""

INITSCRIPT_NAME = "init-trik"
INITSCRIPT_PARAMS = "start 38 S ."

SYSTEMD_SERVICE:${PN} = "trik-hostname.service"

do_install:append() {
    install -m 0644 ${S}/issue      ${D}${sysconfdir}/issue
    install -m 0644 ${S}/issue.net  ${D}${sysconfdir}/issue.net
    install -m 0644 ${S}/fstab.trik ${D}${sysconfdir}/fstab

    install -m 0644 ${S}/rotation   ${D}${sysconfdir}/rotation

    install -d ${D}${libexecdir}/trik
    install -m 0755 ${S}/trik-hostname.sh   ${D}${libexecdir}/trik/
    install -m 0755 ${S}/trik-serial-number ${D}${libexecdir}/trik/

    install -d ${D}${sysconfdir}/init.d
    install -m 0755 ${S}/init-trik ${D}${sysconfdir}/init.d/

    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${S}/trik-hostname.service ${D}${systemd_system_unitdir}/
}

FILES:${PN} += " \
    ${sysconfdir}/init.d/ \
    ${libexecdir}/trik \
    ${sysconfdir}/rotation \
"
