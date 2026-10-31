SUMMARY = "Multimedia libraries package"
DESCRIPTION = "Multimedia libraries and utilities"
LICENSE = "LGPL-2.0-only"
PR = "r4"

inherit packagegroup

RDEPENDS:${PN} = "\
  alsa-utils \
  espeak \
  v4l-utils \
  gstreamer1.0-plugins-good \
  gstreamer1.0-plugins-bad \
  gstreamer1.0-plugins-bad-v4l2codecs \
  gstreamer1.0-meta-video \
  gstreamer1.0-plugins-base \
  gstreamer1.0-meta-audio \
  gstreamer1.0-rtsp-server \
  gstreamer1.0-rockchip \
  rockchip-mpp \
  flac \
  mediamtx \
 "
#vlc
#  ffmpeg
RRECOMMENDS:${PN} = "\
 "
#pocketsphinx 
#  sox 
#  bigbuckbunny-480p

