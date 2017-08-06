#!/usr/bin/env bash

export CROSS_COMPILE=aarch64-linux-gnu-
export ARCH=arm64
export JOBS=$(nproc)
	
cd /linux 

make -j${JOBS} ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- bcmrpi3_defconfig
# make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- menuconfig
make -j${JOBS} ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- LOCALVERSION="-arm64" Image
make -j${JOBS} ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- LOCALVERSION="-arm64" dtbs
make -j${JOBS} ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- LOCALVERSION="-arm64" modules


mkdir -p /output/RPIROOT/boot
make -j ${JOBS} INSTALL_MOD_PATH=/output/RPIROOT ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- modules_install

cp -rf /linux/arch/arm64/boot/Image /output/RPIROOT/boot/kernel8.img
cp -rf /linux/arch/arm64/boot/dts/broadcom/bcm2710-rpi-3-b.dtb /output/RPIROOT/boot/
cp -rf /linux/arch/arm/boot/dts/overlays /output/RPIROOT/boot/overlays

cd /output/RPIROOT && tar -cvzf kernel64-4.9.40.tar.gz *