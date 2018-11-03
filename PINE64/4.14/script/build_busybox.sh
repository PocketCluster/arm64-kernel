#!/usr/bin/env bash

set -x

source /script/common.sh
export SUBFOLDER="busybox"

cp -fv ${CONFIG}/busybox.config ${BUSYBOX}/.config && cd ${BUSYBOX}

make ${CROSS_COMPILE_FLAG} clean
make -j${JOBS} ${CROSS_COMPILE_FLAG} oldconfig
make -j${JOBS} ${CROSS_COMPILE_FLAG}

mkdir -p ${DEST}/${SUBFOLDER}
cp -v busybox ${DEST}/${SUBFOLDER}

rm .config*