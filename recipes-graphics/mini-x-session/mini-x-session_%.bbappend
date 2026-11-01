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
exec matchbox-window-manager -theme blondie -use_titlebar no -use_cursor no -use_desktop_mode plain -use_lowlight no -use_super_modal no
EOF
	chmod +x $C/session
}
