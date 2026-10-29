COMPATIBLE_MACHINE = "trikboard"

SRC_URI = "git://github.com/trikset/trik-barebox.git;protocol=https;branch=trik"
SRCREV = "c9fc752b7c96091ee6c428f99e84d425cfcc57e0"

BAREBOX_IMAGE_SRC = "images/barebox-diasom-rk3568-som-evb.img"

DEPENDS += "openssl-native libusb1-native pkgconfig-native"

# TODO: dirty sysroot/pkg-config substitution hack for the barebox build - revisit.
do_compile:prepend() {
    unset PKG_CONFIG_SYSROOT_DIR
    export PKG_CONFIG_PATH="${STAGING_LIBDIR_NATIVE}/pkgconfig:${STAGING_DATADIR_NATIVE}/pkgconfig"
}
