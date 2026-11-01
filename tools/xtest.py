#!/usr/bin/env python3
"""Minimal XTEST input injector for the TRIK X session.

Needs only python3-ctypes, libX11 and libXtst (all already in the image).

Usage:
    DISPLAY=:0 xtest.py move X Y
    DISPLAY=:0 xtest.py click X Y [button]
    DISPLAY=:0 xtest.py down X Y [button]
    DISPLAY=:0 xtest.py up [button]
    DISPLAY=:0 xtest.py scroll up|down [count]
    DISPLAY=:0 xtest.py key NAME [NAME...]
    DISPLAY=:0 xtest.py type TEXT
    DISPLAY=:0 xtest.py serve          # read commands from stdin, one per line
"""

import ctypes
import os
import sys
import time

X11 = ctypes.CDLL("libX11.so.6")
XTST = ctypes.CDLL("libXtst.so.6")

X11.XOpenDisplay.restype = ctypes.c_void_p
X11.XOpenDisplay.argtypes = [ctypes.c_char_p]
X11.XFlush.argtypes = [ctypes.c_void_p]
X11.XStringToKeysym.restype = ctypes.c_ulong
X11.XStringToKeysym.argtypes = [ctypes.c_char_p]
X11.XKeysymToKeycode.restype = ctypes.c_ubyte
X11.XKeysymToKeycode.argtypes = [ctypes.c_void_p, ctypes.c_ulong]

XTST.XTestFakeMotionEvent.argtypes = [
    ctypes.c_void_p, ctypes.c_int, ctypes.c_int, ctypes.c_int, ctypes.c_ulong,
]
XTST.XTestFakeButtonEvent.argtypes = [
    ctypes.c_void_p, ctypes.c_uint, ctypes.c_int, ctypes.c_ulong,
]
XTST.XTestFakeKeyEvent.argtypes = [
    ctypes.c_void_p, ctypes.c_uint, ctypes.c_int, ctypes.c_ulong,
]

DISPLAY = os.environ.get("DISPLAY", ":0").encode()
dpy = X11.XOpenDisplay(DISPLAY)
if not dpy:
    sys.exit("xtest: cannot open display %s" % DISPLAY.decode())

SCREEN = 0


def flush(delay=0.02):
    X11.XFlush(dpy)
    time.sleep(delay)


def move(x, y):
    XTST.XTestFakeMotionEvent(dpy, SCREEN, int(x), int(y), 0)
    flush()


def button(btn, press):
    XTST.XTestFakeButtonEvent(dpy, int(btn), 1 if press else 0, 0)
    flush(0.01)


def click(x, y, btn=1):
    move(x, y)
    button(btn, True)
    button(btn, False)


def keycode(name):
    sym = X11.XStringToKeysym(name.encode())
    if not sym:
        return None
    return X11.XKeysymToKeycode(dpy, sym)


def tap(name, shift=False):
    code = keycode(name)
    if not code:
        sys.stderr.write("xtest: unknown key '%s'\n" % name)
        return
    shift_code = keycode("Shift_L") if shift else None
    if shift_code:
        XTST.XTestFakeKeyEvent(dpy, shift_code, 1, 0)
    XTST.XTestFakeKeyEvent(dpy, code, 1, 0)
    XTST.XTestFakeKeyEvent(dpy, code, 0, 0)
    if shift_code:
        XTST.XTestFakeKeyEvent(dpy, shift_code, 0, 0)
    flush(0.01)


def type_text(text):
    for ch in text:
        if ch == "\n":
            tap("Return")
        elif ch == " ":
            tap("space")
        elif ch.isupper():
            tap(ch.lower(), shift=True)
        else:
            tap(ch)


def serve():
    for line in sys.stdin:
        run(line.split())
        sys.stdout.write("ok\n")
        sys.stdout.flush()


def run(argv):
    if not argv:
        return
    cmd = argv[0]
    args = argv[1:]
    if cmd == "move":
        move(args[0], args[1])
    elif cmd == "click":
        btn = int(args[2]) if len(args) > 2 else 1
        click(args[0], args[1], btn)
    elif cmd == "down":
        btn = int(args[2]) if len(args) > 2 else 1
        move(args[0], args[1])
        button(btn, True)
    elif cmd == "up":
        btn = int(args[0]) if args else 1
        button(btn, False)
    elif cmd == "scroll":
        direction = args[0] if args else "down"
        count = int(args[1]) if len(args) > 1 else 3
        btn = 4 if direction == "up" else 5
        for _ in range(count):
            button(btn, True)
            button(btn, False)
    elif cmd == "key":
        for name in args:
            tap(name)
    elif cmd == "type":
        type_text(" ".join(args))
    elif cmd == "serve":
        serve()
    else:
        sys.exit("xtest: unknown command '%s'" % cmd)


if __name__ == "__main__":
    run(sys.argv[1:])
