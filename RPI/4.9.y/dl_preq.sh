#!/usr/bin/env bash

set -x

export PATCH_KERNEL_AUFS=${PATCH_KERNEL_AUFS:-0}

# --- Download Main Kernel ---
if [[ ! -d "linux" ]]; then
	export LINUX_REPO=${LINUX_REPO:-"https://github.com/raspberrypi/linux.git"}
	export LINUX_BRANCH=${LINUX_BRANCH:-"rpi-4.9.y"}
	export LINUX_COMMIT=${LINUX_COMMIT:-"a6d7c7353dfd938f8f5c6d6f33813f2c4b3ff7dc"}

	pushd ${PWD}
		#git clone --depth=1 -b rpi-4.9.y https://github.com/raspberrypi/linux.git
		git clone -b ${LINUX_BRANCH} ${LINUX_REPO}
		cd linux
		git checkout -q ${LINUX_COMMIT}
	popd

	tar -cvzf "${PWD}/linux-src-${LINUX_BRANCH}-${LINUX_COMMIT}.tar.gz"
fi

# --- Download AUFS. We use AUFS_COMMIT to get stronger repeatability guarantees ---
#   http://aufs.sourceforge.net/
if [[ ! -d "aufs-standalone" ]]; then
	export AUFS_REPO=${AUFS_REPO:-"https://github.com/sfjro/aufs4-standalone"}
	export AUFS_BRANCH=${AUFS_BRANCH:-"aufs4.9"}
	export AUFS_COMMIT=${AUFS_COMMIT:-"c8baf66741e7440a3f6dc5b88b188c6827058014"}

	pushd ${PWD}
		git clone -b "$AUFS_BRANCH" "$AUFS_REPO" aufs-standalone
		cd aufs-standalone
		git checkout -q "$AUFS_COMMIT"
	popd
	tar -cvzf "${PWD}/${AUFS_BRANCH}-${AUFS_COMMIT}.tar.gz" ./aufs-standalone
fi

# apply AUFS patches and files
if [[ ${PATCH_KERNEL_AUFS} -eq 1 ]];then
	pushd ${PWD}
    cp -r aufs-standalone/Documentation linux
    cp -r aufs-standalone/fs linux
    cp -r aufs-standalone/include/uapi/linux/aufs_type.h linux/include/uapi/linux/
    cd linux
    set -e && for patch in \
        ../aufs-standalone/aufs*-kbuild.patch \
        ../aufs-standalone/aufs*-base.patch \
        ../aufs-standalone/aufs*-mmap.patch \
        ../aufs-standalone/aufs*-standalone.patch \
        ../aufs-standalone/aufs*-loopback.patch \
    ; do \
        patch -p1 < "$patch"; \
    done
    popd
fi


#git clone --depth=1 -b master https://github.com/raspberrypi/firmware
