PR="r9"
DESCRIPTION = "TRIK core base v2"
IMAGE_FEATURES += "package-management x11-base"
IMAGE_INSTALL = "packagegroup-base \
		packagegroup-core-boot \
		${CORE_IMAGE_EXTRA_INSTALL} \
		packagegroup-wifi \
		packagegroup-core-ssh-openssh \
		localedef \
		procps \
		packagegroup-firmware \
		packagegroup-utils \
		kernel-image \
		kernel-devicetree \
		udev-extraconf \
		rc-local\
		trik-runtime \
		trik-examples \
		softap-udhcpd-config \
		trik-network \
		fuse \
		eglibc-utils \
		distro-feed-configs \
		formfactor \
		coreutils \
		mini-x-session \
		trik-uart-ppp \
		trik-mems \
		python3-pip \
		packagegroup-ros2-base \
"

BAD_RECOMMENDATIONS += "rng-tools"

IMAGE_LINGUAS = "en-us ru-ru"

LICENSE = "MIT"

inherit core-image

WKS_FILE = "trik-image-core.wks"

IMAGE_ROOTFS_SIZE = "1572864"
