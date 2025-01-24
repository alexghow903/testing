FROM ghcr.io/ublue-os/bazzite:stable

COPY build.sh ./build.sh

RUN ./build.sh && \
    ostree container commit