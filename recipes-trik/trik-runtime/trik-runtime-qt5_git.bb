SRCREV="${AUTOREV}"
TRIK_RUNTIME_UPDATE = "${SRCREV}"
GIT_REVISION = "branch=master"
PV = "git${SRCREV}"
#PR="r${TRIK_RUNTIME_UPDATE}"
require trik-runtime-qt5.inc
DEPENDS += "python3 rsync-native"
DEPENDS += "gcc-sanitizers"
RDEPENDS:${PN} += "bash xz"

require trik-runtime-install-new.inc
DEPENDS += "rsync-native python3"

#OE_QMAKE_CXXFLAGS:append += " -fno-lto"

#We need to switch precompiled headers off until this issue is fixed in trik-runtime sources
#We need to disable sanitize_address until the issue with the high memory consumption of asan is fixed
EXTRA_QMAKEVARS_PRE += "-r CONFIG+=release CONFIG+=ltcg CONFIG+=use_gold_linker \
			CONFIG+=noPch CONFIG+=sanitize_undefined CONFIG+=sanitizer \
			PYTHONQTALL_CONFIG+=PythonQtCore \
			PYTHONQTALL_CONFIG+=PythonQtGui"
TRIK_PYTHON_VERSION = "3.10"
EXTRA_QMAKEVARS_PRE += "PYTHON_VERSION=${TRIK_PYTHON_VERSION} PKGCONFIG+=python-${TRIK_PYTHON_VERSION}-embed"
# For script gathering logs information
RDEPENDS:${PN} += "bash xz"
INHIBIT_PACKAGE_DEBUG_SPLIT = "1"
#INHIBIT_PACKAGE_STRIP = "1"
#DEBUG_BUILD = "1"
