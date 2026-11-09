COMPATIBLE_MACHINE = "trikboard"

SRC_URI = "git://github.com/trikset/trik-barebox.git;protocol=https;branch=trik"
SRCREV = "${AUTOREV}"

# TODO: replace the non-dev image with the production carrier image.
BAREBOX_IMAGE_SRC = "${@bb.utils.contains('TRIKBOARD_VARIANT', 'dev', 'images/barebox-diasom-rk3568-som-evb.img', 'images/barebox-trikboard.img', d)}"

DEPENDS += "openssl-native libusb1-native pkgconfig-native"

# TODO: dirty sysroot/pkg-config substitution hack for the barebox build - revisit.
do_compile:prepend() {
    unset PKG_CONFIG_SYSROOT_DIR
    export PKG_CONFIG_PATH="${STAGING_LIBDIR_NATIVE}/pkgconfig:${STAGING_DATADIR_NATIVE}/pkgconfig"
}
