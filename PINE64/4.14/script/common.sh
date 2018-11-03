#!/bin/bash

export CROSS_COMPILE=aarch64-linux-gnu-
export ARCH=arm64
export CROSS_COMPILE_FLAG="ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE} LOCALVERSION=${ARCH}"

export JOBS=$(nproc)
export DEST="/output"

export CONFIG="/config"
export LINUX="/linux"
export BUSYBOX="/busybox"
export FIRMWARE="/arm-trusted-firmware"
export UBOOT="/u-boot"