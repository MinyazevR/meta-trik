PACKAGECONFIG_FONTS = "fontconfig freetype"
#PACKAGECONFIG[dyngl] = "-opengl dynamic,,,"
PACKAGECONFIG_GL = "${@bb.utils.contains('DISTRO_FEATURES', 'x11 opengl', 'gles2', \
                        bb.utils.contains('DISTRO_FEATURES', 'opengl', 'kms gbm gles2 eglfs', \
                                          'no-opengl', d), d)}"
#PACKAGECONFIG_FB = "directfb linuxfb"
PACKAGECONFIG_DISTRO = "icu optimize-size"
#PACKAGECONFIG_DISTRO += "ltcg"
#QT_CONFIG_FLAGS += " -reduce-relocations " commented out until QTBUG-36129 is fixed
#QT_CONFIG_FLAGS += "-force-asserts -qreal float"
#QT_CONFIG_FLAGS += "-ltcg"
#OE_QMAKE_CXXFLAGS:append += " -ffat-lto-objects -ffunction-sections "
#OE_QMAKE_LFLAGS:append += " -ffunction-sections "
#INHIBIT_PACKAGE_DEBUG_SPLIT = "1"
#INHIBIT_PACKAGE_STRIP = "1"
#DEBUG_BUILD = "1"
