# Base image
FROM node:18-alpine3.18 AS base

#########################################################################

FROM base AS ffmpeg

# https://github.com/tsaridas/stremio-docker/blob/main/Dockerfile
# We build our own ffmpeg since 4.X is the only one supported
ENV BIN="/usr/bin"
RUN cd && \
  apk add --no-cache --virtual \ 
  .build-dependencies \ 
  gnutls \
  freetype-dev \
  gnutls-dev \
  lame-dev \
  libass-dev \
  libogg-dev \
  libtheora-dev \
  libvorbis-dev \ 
  libvpx-dev \
  libwebp-dev \ 
  libssh2 \
  opus-dev \
  rtmpdump-dev \
  x264-dev \
  x265-dev \
  yasm-dev \
  build-base \ 
  coreutils \ 
  gnutls \ 
  nasm \ 
  dav1d-dev \
  libbluray-dev \
  libdrm-dev \
  zimg-dev \
  aom-dev \
  xvidcore-dev \
  fdk-aac-dev \
  libva-dev \
  git \
  x264 && \
  DIR=$(mktemp -d) && \
  cd "${DIR}" && \
  git clone --depth 1 --branch v4.4.1-4 https://github.com/jellyfin/jellyfin-ffmpeg.git && \
  cd jellyfin-ffmpeg* && \
  PATH="$BIN:$PATH" && \
  ./configure --help && \
  ./configure --bindir="$BIN" --disable-debug \
  --prefix=/usr/lib/jellyfin-ffmpeg --extra-version=Jellyfin --disable-doc --disable-ffplay --disable-shared --disable-libxcb --disable-sdl2 --disable-xlib --enable-lto --enable-gpl --enable-version3 --enable-gmp --enable-gnutls --enable-libdrm --enable-libass --enable-libfreetype --enable-libfribidi --enable-libfontconfig --enable-libbluray --enable-libmp3lame --enable-libopus --enable-libtheora --enable-libvorbis --enable-libdav1d --enable-libwebp --enable-libvpx --enable-libx264 --enable-libx265  --enable-libzimg --enable-small --enable-nonfree --enable-libxvid --enable-libaom --enable-libfdk_aac --enable-vaapi --enable-hwaccel=h264_vaapi --toolchain=hardened && \
  make -j4 && \
  make install && \
  make distclean && \
  rm -rf "${DIR}"  && \
  apk del --purge .build-dependencies

#########################################################################

# Main image
FROM base AS final

ARG VERSION=main
LABEL org.opencontainers.image.source=https://github.com/fopina/stremio-docker
LABEL org.opencontainers.image.description="Stremio Server"
LABEL org.opencontainers.image.licenses=MIT
LABEL version=${VERSION}

WORKDIR /stremio

# FIXME: official image does not install any of this, only tsaridas/stremio-docker - is it because of stremio-web?
# # Add libs
# RUN apk add --no-cache \
#             libwebp \
#             libvorbis \
#             x265-libs \
#             x264-libs \
#             libass \
#             opus \
#             libgmpxx \
#             lame-libs \
#             gnutls \
#             libvpx \
#             libtheora \
#             libdrm \
#             libbluray \
#             zimg \
#             libdav1d \
#             aom-libs \
#             xvidcore \
#             fdk-aac \
#             libva \
#             curl

# # Add arch specific libs
# RUN if [ "$(uname -m)" = "x86_64" ]; then \
#   apk add --no-cache intel-media-driver; \
#   fi

# Copy ffmpeg
COPY --from=ffmpeg /usr/bin/ffmpeg /usr/bin/ffprobe /usr/bin/
COPY --from=ffmpeg /usr/lib/jellyfin-ffmpeg /usr/lib/

COPY server.js ./

###
# same settings as in https://github.com/Stremio/server-docker/blob/main/Dockerfile below
###
VOLUME ["/root/.stremio-server"]
# http / https
EXPOSE 11470 12470
# full path to the ffmpeg binary
ENV FFMPEG_BIN=
# full path to the ffprobe binary
ENV FFPROBE_BIN=
# Custom application path for storing server settings, certificates, etc
ENV APP_PATH=
# Use `NO_CORS=1` to disable the server's CORS checks
ENV NO_CORS=
# "Docker image shouldn't attempt to find network devices or local video players."
# See: https://github.com/Stremio/server-docker/issues/7
ENV CASTING_DISABLED=1

ENTRYPOINT [ "node", "server.js" ]