FROM ubuntu:xenial

RUN apt-get update && \
    apt-get install -y unzip libncurses-dev dialog bc gcc-aarch64-linux-gnu device-tree-compiler git ca-certificates build-essential libc6-dev-arm64-cross wget fakeroot debhelper gawk kmod cpio bison flex python python-dev swig --no-install-recommends

COPY ./build_kernel.sh /
