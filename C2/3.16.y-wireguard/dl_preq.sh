#!/usr/bin/env bash

set -x

export PATCH_KERNEL_AUFS=${PATCH_KERNEL_AUFS:-0}
export PATCH_KERNEL_WIREGUARD=${PATCH_KERNEL_WIREGUARD:-0}

# --- Download Main Kernel ---
if [[ ! -d "linux" ]]; then
    export LINUX_REPO=${LINUX_REPO:-"https://github.com/hardkernel/linux.git"}
    export LINUX_BRANCH=${LINUX_BRANCH:-"odroidc2-v3.16.y"}
    export LINUX_COMMIT=${LINUX_COMMIT:-"2457e39a1b4a270ad51031a5c9d3abf1303dd7d7"}

    pushd ${PWD}
        #git clone --depth=1 -b rpi-4.9.y https://github.com/raspberrypi/linux.git
        git clone -b ${LINUX_BRANCH} --depth=1 ${LINUX_REPO} &&\
        cd linux &&\
        git checkout -q ${LINUX_COMMIT}
    popd

    tar -cvzf "${PWD}/linux-src-${LINUX_BRANCH}-${LINUX_COMMIT}.tar.gz" linux
fi

# --- Download Wireguard ---
if [[ ${PATCH_KERNEL_WIREGUARD} -eq 1 ]];then
    export WG_REPO=${WG_REPO:-"https://git.zx2c4.com/WireGuard"}
    export WG_BRANCH=${WG_MASTER:-"master"}
    export WG_COMMIT=${WG_VERSION:-"0.0.20181018"}

    pushd ${PWD}
    git clone -b ${WG_BRANCH} ${WG_REPO} &&\
    cd WireGuard &&\
    git checkout -q ${WG_COMMIT}
    popd

    tar -cvzf "${PWD}/WireGuard-src-${WG_BRANCH}-${WG_COMMIT}.tar.gz" WireGuard

    pushd ${PWD}
    cd linux &&\
    ../WireGuard/contrib/kernel-tree/create-patch.sh | patch -p1
    popd

fi

# apply pre-configured config (aufs + vxlan support)
#cp rpi_wireguard_config linux/.config

#git clone --depth=1 -b master https://github.com/raspberrypi/firmware
