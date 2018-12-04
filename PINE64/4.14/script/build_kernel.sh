#!/usr/bin/env bash

set -x

source /script/common.sh
export SUBFOLDER="kernel"
export INSTALL_PATH="${DEST}/${SUBFOLDER}"

cp -fv ${CONFIG}/kernel-wg-iptable.config ${LINUX}/.config && cd ${LINUX} 

make ${CROSS_COMPILE_FLAG} clean

# in case you need manual config (e.g. WireGuard)
#make -j${JOBS} ${CROSS_COMPILE_FLAG} menuconfig

make -j${JOBS} ${CROSS_COMPILE_FLAG} Image
make -j${JOBS} ${CROSS_COMPILE_FLAG} dtbs
make -j${JOBS} ${CROSS_COMPILE_FLAG} modules

VERSION=$(strings $LINUX/arch/arm64/boot/Image | grep "Linux version"| awk '{print $3}')
echo "Kernel build version : $VERSION ..."
if [ -z "$VERSION" ]; then
	echo "Failed to get build version, correct <linux-folder>?"
	exit 1
fi

# make output path
mkdir -p "${INSTALL_PATH}/boot/dtb"

# copy Kernel
cp -vf "${LINUX}/arch/arm64/boot/Image" "${INSTALL_PATH}/boot"
echo "${VERSION}" > "${INSTALL_PATH}/boot/Image.version"
cp -vf "${LINUX}/System.map" "${INSTALL_PATH}/boot"
cp -vf "${LINUX}/.config" "${INSTALL_PATH}/boot/config"

# copy binary device tree
if [ -d "${LINUX}/arch/arm64/boot/dts/allwinner" ]; then
	# Seems to be mainline Kernel.
	if [ ! -e "${LINUX}/arch/arm64/boot/dts/allwinner/sun50i-a64-pine64-plus.dtb" ]; then
		echo "Error: DTB not found at ${LINUX}/arch/arm64/boot/dts/allwinner/"
		exit 1
	fi
	cp -v "${LINUX}/arch/arm64/boot/dts/allwinner/"*.dtb "${INSTALL_PATH}/boot/dtb"
else
	basename="pine64"
	if grep -q sunxi-drm "${LINUX}/arch/arm64/boot/Image"; then
		echo "Kernel with DRM driver!"
		basename="pine64drm"
	fi
fi

sync
echo "Done - boot files in ${INSTALL_PATH}/boot"

make -j${JOBS} ${CROSS_COMPILE_FLAG} INSTALL_MOD_PATH="${INSTALL_PATH}" modules_install
#make -j${JOBS} ${CROSS_COMPILE_FLAG} INSTALL_MOD_PATH="${INSTALL_PATH}" firmware_install
make -j${JOBS} ${CROSS_COMPILE_FLAG} INSTALL_HDR_PATH="${INSTALL_PATH}" headers_install
#make -j${JOBS} ${CROSS_COMPILE_FLAG} KBUILD_IMAGE=arch/arm64/boot/Image deb-pkg 

# fix symbolic links
rm -f "${INSTALL_PATH}/lib/modules/$VERSION/source"
rm -f "${INSTALL_PATH}/lib/modules/$VERSION/build"

# clear residue
rm .config*

sync
echo "Done - installed Kernel modules to $DEST"
