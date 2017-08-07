#!/usr/bin/env bash

export CROSS_COMPILE=aarch64-linux-gnu-
export ARCH=arm64
export JOBS=$(nproc)
	
cd /linux 

if [[ ! -f .config ]]; then

	make -j${JOBS} ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- bcmrpi3_defconfig
	# make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- menuconfig
	: <<'EXTRA_CFG_ADDED'
CONFIG_AUFS_FS=y
# CONFIG_AUFS_BRANCH_MAX_127 is not set
# CONFIG_AUFS_BRANCH_MAX_511 is not set
# CONFIG_AUFS_BRANCH_MAX_1023 is not set
CONFIG_AUFS_BRANCH_MAX_32767=y
CONFIG_AUFS_SBILIST=y
# CONFIG_AUFS_HNOTIFY is not set
# CONFIG_AUFS_EXPORT is not set
CONFIG_AUFS_XATTR=y
# CONFIG_AUFS_FHSM is not set
# CONFIG_AUFS_RDU is not set
# CONFIG_AUFS_SHWH is not set
# CONFIG_AUFS_BR_RAMFS is not set
# CONFIG_AUFS_BR_FUSE is not set
CONFIG_AUFS_BR_HFSPLUS=y
CONFIG_AUFS_BDEV_LOOP=y
# CONFIG_AUFS_DEBUG is not set

CONFIG_VXLAN=y
EXTRA_CFG_ADDED

fi 

make -j${JOBS} ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- LOCALVERSION="-arm64" Image
make -j${JOBS} ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- LOCALVERSION="-arm64" dtbs
make -j${JOBS} ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- LOCALVERSION="-arm64" modules


mkdir -p /output/RPIROOT/boot
make -j ${JOBS} INSTALL_MOD_PATH=/output/RPIROOT ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- modules_install

cp -rf /linux/arch/arm64/boot/Image /output/RPIROOT/boot/kernel8.img
cp -rf /linux/arch/arm64/boot/dts/broadcom/bcm2710-rpi-3-b.dtb /output/RPIROOT/boot/
cp -rf /linux/arch/arm/boot/dts/overlays /output/RPIROOT/boot/overlays

rm -rf /output/RPIROOT/boot/overlays/.*.tmp
rm -rf /output/RPIROOT/boot/overlays/.*.cmd
rm -rf /output/RPIROOT/boot/overlays/*.dts

cd /output/RPIROOT && tar -cvzf kernel64-4.9.40.tar.gz *