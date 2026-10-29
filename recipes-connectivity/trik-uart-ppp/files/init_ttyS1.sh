#!/bin/bash
# Copyright 2019 CyberTech Labs Co Ltd.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# TODO: verify the real UART device on a board sample (ttyS1 is carried over from OMAP-L138).
device="ttyS1"
baudrate=115200

. /etc/default/ttyS1

exec_login() {
  exec getty -L $device $baudrate -n -l /etc/trik/autologin
}

exec_start_pppd() {
  exec </dev/null >/dev/null 2>&1
  mknod /dev/ppp c 108 0
  exec pppd $device $baudrate 10.0.5.2:10.0.5.1 \
    connect 'chat -v -f /etc/ppp/winclient.chat' \
    nodetach noauth local debug dump defaultroute nocrtscts persist maxfail 0 holdoff 10 \
    lcp-echo-interval 3 lcp-echo-failure 1
}

exec_nothing() {
  # detach from console
  exec </dev/null >/dev/null 2>&1
  exec sleep infinity
}

case "$LINE_PROTOCOL" in
ppp)
  exec_start_pppd
  ;;
getty|login)
  exec_login
  ;;
lidar|nothing)
  exec_nothing
  ;;
*)
  exec_login
  ;;
esac
