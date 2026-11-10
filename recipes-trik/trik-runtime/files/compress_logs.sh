#!/bin/sh
exec nice -n 5 /etc/trik/log_manager.sh --gc
