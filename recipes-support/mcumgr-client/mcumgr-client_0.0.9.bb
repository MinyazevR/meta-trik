SUMMARY = "Rust MCUmgr CLI - fast firmware upload for MCUboot"
HOMEPAGE = "https://github.com/vouch-opensource/mcumgr-client"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"
COMPATIBLE_MACHINE = "trikboard"

SRC_URI = "https://github.com/vouch-opensource/mcumgr-client/releases/download/v0.0.9/mcumgr-client-linux-aarch64.zip"
SRC_URI[sha256sum] = "961ce19668922383aad822e19688a814d39753f052301f64d81c46beaefc39f7"

S = "${WORKDIR}"

do_install() {
	install -d ${D}${bindir}
	install -m 0755 mcumgr-client-linux-aarch64/mcumgr-client ${D}${bindir}/
}
