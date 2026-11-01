#!/bin/sh
set -eu

DISPLAY="${DISPLAY:-:0}"
auth=""

pid="$(pidof Xorg 2>/dev/null || true)"
if [ -n "$pid" ]; then
	for p in $pid; do
		if [ -r "/proc/$p/environ" ]; then
			auth="$(tr '\0' '\n' < "/proc/$p/environ" | sed -n 's/^XAUTHORITY=//p' | head -n 1)"
			[ -n "$auth" ] && break
		fi
	done
fi
if [ -n "$auth" ] && [ -e "$auth" ]; then
	exec /usr/bin/x11vnc -display "$DISPLAY" -auth "$auth" \
		-forever -shared -localhost -rfbport 5900 -noxdamage
fi

exec /usr/bin/x11vnc -display "$DISPLAY" \
	-forever -shared -localhost -rfbport 5900 -noxdamage
