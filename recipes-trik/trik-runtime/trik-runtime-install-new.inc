do_install() {
        install -d ${D}/home/root/trik
        install -m 0666 -t ${D}/home/root/trik/ ${S}/resources/lsan.supp
        rsync -rlptv --exclude '*.a' ${B}/bin/* ${D}/home/root/trik
        install -d ${D}/home/root/trik/scripts
        install -d ${D}/home/root/trik/images
        install -d ${S}/trikControl/configs/ ${D}/home/root/trik/

        install -d ${D}${libexecdir}/trik ${D}${sysconfdir}/trik/
        install -m 0755 ${WORKDIR}/trikGui.sh ${D}${libexecdir}/trik/trikGui.sh
        ln -sf ${libexecdir}/trik/trikGui.sh ${D}${sysconfdir}/trik/trikGui.sh
        install -m 0755 ${WORKDIR}/say ${D}${libexecdir}/trik/say
        ln -sf ${libexecdir}/trik/say ${D}${sysconfdir}/trik/say
        install -m 0755 ${WORKDIR}/log_manager.sh ${D}${libexecdir}/trik/log_manager.sh
        ln -sf ${libexecdir}/trik/log_manager.sh ${D}${sysconfdir}/trik/log_manager.sh
        install -m 0755 ${WORKDIR}/compress_logs.sh ${D}${libexecdir}/trik/compress_logs.sh

        install -d ${D}${systemd_system_unitdir}
        install -m 0644 ${WORKDIR}/gamepad.service ${D}${systemd_system_unitdir}/
        install -m 0644 ${WORKDIR}/trikGui.service ${D}${systemd_system_unitdir}/
        install -m 0644 ${WORKDIR}/trik-log-gc.service ${D}${systemd_system_unitdir}/

        install -d ${D}${sysconfdir}/profile.d/
        install -m 0755 ${WORKDIR}/qws_display.sh ${D}${sysconfdir}/profile.d/
        install -m 0755 ${WORKDIR}/trik_runtime_path.sh ${D}${sysconfdir}/profile.d/
        install -m 0755 ${WORKDIR}/python_path.sh ${D}${sysconfdir}/profile.d/

        LIBS="trikCommunicator \
              trikControl \
              trikHal \
              trikKernel \
              trikNetwork \
              trikScriptRunner \
              trikTelemetry \
              trikWiFi"

        install -d ${D}${includedir}/trikRuntime
        cp -rf ${S}/qslog/qslog/*.h ${D}${includedir}/trikRuntime
        for lib in $LIBS; do
            cp -rf ${S}/${lib}/include/* ${D}${includedir}/trikRuntime/${lib}
        done

        install -d ${D}${libdir}
        rsync -rlptv ${B}/bin/lib*.so* ${D}${libdir}

        for lib in $(ls ${D}${libdir}); do
            ln -sf ${libdir}/${lib} ${D}/home/root/trik/${lib}
        done
}
