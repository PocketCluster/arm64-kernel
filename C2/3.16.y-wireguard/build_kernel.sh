#!/usr/bin/env bash

export CROSS_COMPILE=aarch64-linux-gnu-
export ARCH=arm64
export JOBS=$(nproc)
	
cd /linux 

make -j${JOBS} ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- LOCALVERSION="-arm64" clean
make -j${JOBS} ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- LOCALVERSION="-arm64" odroidc2_defconfig

# in case you need manual config (e.g. WireGuard)
make -j${JOBS} ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- LOCALVERSION="-arm64" menuconfig

make -j${JOBS} ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- LOCALVERSION="-arm64" Image
make -j${JOBS} ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- LOCALVERSION="-arm64" dtbs
make -j${JOBS} ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- LOCALVERSION="-arm64" modules


mkdir -p /output/C2/boot
make -j${JOBS} ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- LOCALVERSION="-arm64" modules_install INSTALL_MOD_PATH=/output/C2 ARCH=arm64 

cp -rf /linux/arch/arm64/boot/Image /output/C2/boot/
cp -rf /linux/arch/arm64/boot/dts/meson64_odroidc2.dtb /output/C2/boot/

cd /output/C2 && tar -cvzf kernel64-3.16.60.tar.gz *

echo "lib/modules/3.16.60-arm64/modules.* files need to generated from an actually booted host with 'depmod' command!!!"
echo "lib/modules/3.16.60-arm64/modules.* files should then be copied and rebuild archive file!!!"
