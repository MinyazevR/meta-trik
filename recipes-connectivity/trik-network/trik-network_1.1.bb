HOMEPAGE = "http://trikset.com"
SECTION = "kernel/userland"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/${LICENSE};md5=89aea4e17d99a7cacdbeed46a0096b10"
SUMMARY = "Shell scripts and configuration files for managing network on TRIK controller"

SRC_URI="\
         file://set_wifi_mode.sh \
         file://20-init_wifi.sh \
         "
RDEPENDS:${PN} += "bash"

FILES:${PN} += "${datadir}/trik"

S = "${WORKDIR}"

do_configure() {
   :
}
do_compile() {
	:
}
do_install() {
	install -D -m 755 -t ${D}${datadir}/trik/init.d/ \
		    ${S}/20-init_wifi.sh

	install -D -m 755 -t ${D}${sysconfdir}/trik/ \
	            ${S}/set_wifi_mode.sh
}
