DESCRIPTION = "Runtime for TRIK controller"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=175792518e4ac015ab6696d16c4f607e"
RDEPENDS:${PN} = "locale-default espeak alsa-utils v4l-utils liberation-fonts mjpg-streamer"

#RRECOMMENDS:${PN} = "vlc"

inherit qmake5 pkgconfig systemd
DEPENDS += "qtmultimedia qtscript qttools-native qtserialport"
DEPENDS += "qtquickcontrols2 qtquickcontrols qtdeclarative qtsvg"

# ros2 depends
DEPENDS += "rclcpp sensor-msgs"

#RREPLACES:${PN} += "trik-runtime"
RCONFLICTS:${PN} += "trik-runtime-qt4"
RPROVIDES:${PN} += "trik-runtime"

SYSTEMD_SERVICE:${PN} = "gamepad.service trikGui.service trik-log-gc.service"
TAG ?= "${PV}-${TRIK_RUNTIME_UPDATE}"
#GIT_REVISION ?= "tag=${TAG};nobranch=1"
SRCREV = "${AUTOREV}"
SRC_URI = "gitsm://github.com/trikset/trikRuntime.git;protocol=https;${GIT_REVISION} \
          file://trikGui.sh \
          file://trikGui.service \
          file://qws_display.sh \
          file://trik_runtime_path.sh \
          file://python_path.sh \
          file://log_manager.sh \
          file://compress_logs.sh \
          file://trik-log-gc.service \
          file://say \
          file://gamepad.service"

S = "${WORKDIR}/git"

QMAKE_PROFILES = "${S}/trikRuntime.pro"
EXTRA_QMAKEVARS_PRE += "PYTHONQT_GENERATED_PATH=${S}/PythonQt/PythonQt/generated_cpp_`${OE_QMAKE_QMAKE} -query QT_VERSION`_triksdk"

do_compile(){
        oe_runmake
}

FILES:${PN} += "${datadir} ${libexecdir}/trik ${systemd_system_unitdir}"


FILES:${PN} += "/home/root/trik/"
#FILES:${PN}-conf += "${sysconfdir}"
#FILES:${PN}-dev += "${includedir}/trikRuntime/*"
#FILES:${PN} += "${libdir}"
FILES:${PN}-dev += "/home/root/trik/*.so"
#FILES:${PN}-dbg += "/home/root/trik/.debug"

pkg_postinst:${PN} () {
        killall trikGui || true
        sleep 3
        killall -9 trikGui 2> /dev/null || true
}

