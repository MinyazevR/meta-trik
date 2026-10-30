DESCRIPTION = "Software for various robots built using TRIK (http://www.trikset.com/) constructor"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=19cbd64715b51267a47bf3750cc6a8a5"
# TEMP: trikRuntime is not built right now.
# RDEPENDS:${PN} = "trik-runtime v4l-utils gawk libv4l"
RDEPENDS:${PN} = "v4l-utils gawk libv4l"
BRANCH  = "master"
SRCREV  = "${AUTOREV}"
SRC_URI = "git://github.com/trikset/trik-models.git;protocol=https;branch=${BRANCH}"
PV="0-git${SRCPV}"
S = "${WORKDIR}/git"

do_compile(){
	  bbnote "Empty do_compile task"
}
do_install(){
	install -d ${D}/home/root/trik/trik-examples/
	cp -rvf ${S}/* ${D}/home/root/trik/trik-examples/
}
FILES:${PN} = "/home/root/trik/trik-examples"
INHIBIT_SYSROOT_STRIP = "1"
INHIBIT_PACKAGE_STRIP = "1"
INHIBIT_PACKAGE_DEBUG_SPLIT = "1"

INSANE_SKIP:${PN} = "ldflags arch"

