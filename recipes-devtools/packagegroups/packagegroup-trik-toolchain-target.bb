SUMMARY = "Provides extra target libs for TRIK toolchain"
LICENSE = "MIT"

PR = "r3"

PACKAGE_ARCH = "${TUNE_PKGARCH}"

inherit packagegroup

RDEPENDS:${PN} += "\
	linux-libc-headers-dev \
	kernel-dev \
	alsa-dev \
	libnl-dev \
	v4l-utils-dev \
	libv4l-dev \
	boost-dev \
	hidapi-dev \
	libusb1-dev \
	protobuf-dev  \
	rockchip-mpp-dev \
	gstreamer1.0-dev \
	gstreamer1.0-plugins-base-dev \
	gstreamer1.0-plugins-bad-dev \
	gstreamer1.0-rtsp-server-dev \
	gcc-sanitizers \
"
# TEMP: trikRuntime is not built right now.
# RDEPENDS:${PN} += "trik-runtime-qt5-dev"

# trik-ros-dev

