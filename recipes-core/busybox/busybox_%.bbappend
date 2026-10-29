FILESEXTRAPATHS:prepend := "${THISDIR}/${BPN}:"

SRC_URI += "file://busybox.cfg"

SYSTEMD_SERVICE:${PN}-syslog = ""
