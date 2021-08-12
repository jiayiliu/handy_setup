FROM centos:7

WORKDIR /root
# Test ffmpeg
COPY install_ffmpeg.sh /root/
RUN bash install_ffmpeg.sh
# Test opencv3
COPY install_opencv3.sh /root/
RUN bash install_opencv3.sh