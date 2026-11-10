RDEPENDS:${PN} += "xsetroot xrandr"
do_install:append() {
	C="${D}/${sysconfdir}/mini_x"
	mkdir -p $C
	cat > $C/session <<'EOF'
xsetroot -solid green
xset s off
xset s noblank
xset -dpms
xset dpms 0 0 0
if xrandr 2>/dev/null | grep -q '^HDMI-1 connected'; then
	xrandr --output DSI-1 --off --output HDMI-1 --mode 1920x1080 --primary 2>/dev/null \
		|| xrandr --output DSI-1 --off --output HDMI-1 --auto --primary 2>/dev/null || true
fi
exec matchbox-window-manager -theme blondie -use_titlebar no -use_cursor no -use_desktop_mode plain -use_lowlight no -use_super_modal no
EOF
	chmod +x $C/session
}
