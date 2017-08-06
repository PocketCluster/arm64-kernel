FROM ubuntu:xenial

RUN apt-get update && \
	apt-get install -y bc build-essential gcc-aarch64-linux-gnu git unzip

COPY ./build_kernel.sh /
