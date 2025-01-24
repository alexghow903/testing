FROM ghcr.io/ublue-os/bazzite:stable

COPY build.sh ./build.sh

RUN chmod 777 build.sh && \
    ./build.sh && \
    ostree container commit
