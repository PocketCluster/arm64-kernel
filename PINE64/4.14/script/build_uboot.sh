#!/usr/bin/env bash

set -x

source /script/common.sh
export SUBFOLDER="u-boot"

cd ${FIRMWARE}

make clean 
make -j${JOBS} PLAT=sun50i_a64 DEBUG=0 bl31
export BL31=${FIRMWARE}/build/sun50i_a64/release/bl31.bin

echo "===== Building U-Boot ====="
cp -fv ${CONFIG}/uboot.config ${UBOOT}/.config && cd ${UBOOT}

make clean 
make -j${JOBS} oldconfig
make -j${JOBS}

mkdir -p ${DEST}/${SUBFOLDER}
cat spl/sunxi-spl.bin u-boot.itb > "${DEST}/${SUBFOLDER}/u-boot-sunxi-image.spl"

rm .config*
