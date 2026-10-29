DESCRIPTION = "nRF52833 USB UAPI header exported by the trik board kernel"
SECTION = "devel"
LICENSE = "GPL-2.0-only"
COMPATIBLE_MACHINE = "trikboard"
# UAPI header carries "GPL-2.0 WITH Linux-syscall-note"; it is taken from the kernel tree.
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0-only;md5=801f80980d171dd6425610833a22dbe6"

# Take the header from the kernel that is actually shipped on the board.
# The task dependency ensures the kernel tree is staged before we copy it.
do_configure[depends] += "virtual/kernel:do_shared_workdir"
do_configure[noexec] = "1"
do_compile[noexec] = "1"

do_install() {
	install -d ${D}${includedir}/linux
	install -m 0644 \
		${STAGING_KERNEL_DIR}/include/uapi/linux/nrf-usb.h \
		${D}${includedir}/linux/nrf-usb.h
}

# The header lands in the default -dev subpackage (includedir). Disable the
# usual -dev -> ${PN} dependency: ${PN} itself is empty and would not be
# written to the feed. Empty string, not "0" — the value is used verbatim in
# RRECOMMENDS:${PN}-dev.
DEV_PKG_DEPENDENCY = ""
