#!/usr/bin/env bash

export CROSS_COMPILE=aarch64-linux-gnu-
export ARCH=arm64
export JOBS=$(nproc)

export LINUX="/linux"
export DEST="/output"
export SUBFOLDER="pine64"

cd ${LINUX}

make -j${JOBS} ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- sun50iw1p1smp_linux_defconfig
make -j${JOBS} ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- LOCALVERSION= clean

make -j${JOBS} ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- LOCALVERSION= Image
make -j${JOBS} ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- LOCALVERSION= dtbs

VERSION=$(strings $LINUX/arch/arm64/boot/Image | grep "Linux version"| awk '{print $3}')
echo "Kernel build version $VERSION ..."
if [ -z "$VERSION" ]; then
	echo "Failed to get build version, correct <linux-folder>?"
	exit 1
fi

# Clean up
mkdir -p "$DEST/$SUBFOLDER"

# Create and copy Kernel
echo -n "Copying Kernel ..."
cp -vf "$LINUX/arch/arm64/boot/Image" "${DEST}/${SUBFOLDER}"
echo "$VERSION" > "$DEST/Image.version"
echo " OK"

# Create and copy binary device tree
if [ -d "$LINUX/arch/arm64/boot/dts/allwinner" ]; then
	# Seems to be mainline Kernel.
	if [ ! -e "$LINUX/arch/arm64/boot/dts/allwinner/sun50i-a64-pine64-plus.dtb" ]; then
		echo "Error: DTB not found at $LINUX/arch/arm64/boot/dts/allwinner/"
		exit 1
	fi
	echo -n "Copy "
	cp -v "$LINUX/arch/arm64/boot/dts/allwinner/"*.dtb "$DEST/$SUBFOLDER/"
else
	basename="pine64"
	if grep -q sunxi-drm "$LINUX/arch/arm64/boot/Image"; then
		echo "Kernel with DRM driver!"
		basename="pine64drm"
	fi
fi

sync
echo "Done - boot files in $DEST"

make -j${JOBS} ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- LOCALVERSION= modules
make -j${JOBS} ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- modules_install INSTALL_MOD_PATH="$DEST"
make -j${JOBS} ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- firmware_install INSTALL_MOD_PATH="$DEST"

# Fix symbolic links
rm -f "$DEST/lib/modules/$VERSION/source"
rm -f "$DEST/lib/modules/$VERSION/build"
ln -s "/usr/src/linux-headers-$VERSION" "$DEST/lib/modules/$VERSION/build"

sync
echo "Done - installed Kernel modules to $DEST"
