#!/usr/bin/env bash

export CROSS_COMPILE=aarch64-linux-gnu-
export ARCH=arm64
export JOBS=$(($(nproc) / 2))
	
cd /linux 

make -j${JOBS} ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- mvebu_v8_lsp_defconfig
# make -j${JOBS} ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu-
# make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- menuconfig
make -j${JOBS} ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- LOCALVERSION="-arm64" Image
make -j${JOBS} ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- LOCALVERSION="-arm64" dtbs
make -j${JOBS} ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- LOCALVERSION="-arm64" modules
make -j ${JOBS} INSTALL_MOD_PATH=/tmp/modules ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- modules_install

( mv /tmp/modules /output/modules || true )
( cp -rf /linux/arch/arm64/boot /output/arm64-boot || true )
( cp -rf /linux/arch/arm/boot /output/arm-boot || true)