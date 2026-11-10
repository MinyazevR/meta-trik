#!/bin/sh
. /etc/profile.d/locale.sh
. /etc/profile.d/qws_display.sh
which xsetroot >/dev/null &&  xsetroot -solid blue || echo "Missing xsetroot!"
which xset >/dev/null && ( xset s off ; xset s noblank ; xset -dpms ) || echo "Missing xset!"
. /etc/profile.d/trik_runtime_path.sh
. /etc/profile.d/python_path.sh
core_dump=$(/etc/trik/log_manager.sh --create)
export ASAN_OPTIONS=detect_leaks=0:fast_unwind_on_malloc=1:detect_stack_use_after_return=0:disable_coredump=0:detect_odr_violation=0
export LSAN_OPTIONS=suppressions=/home/root/trik/lsan.supp
# Disabling import of the asyncio library for PythonEngine, as it takes ~7 seconds to import.
export PYTHONQT_DISABLE_ASYNCIO=1
cd /home/root/trik && ln -svft . configs/kernel-"$(uname -r | cut -f -2 -d .)"/*.xml configs/ros2/*.xml \
  && nice -n -5 ./trikGui -c . -d ${core_dump} 1>/var/log/trikGui.log 2>&1
rc=$?
[ "$rc" -eq 0 ] || /etc/trik/log_manager.sh --collect ${core_dump}
which xsetroot >/dev/null &&  xsetroot -solid red || echo "Missing xsetroot!"
exit "$rc"
