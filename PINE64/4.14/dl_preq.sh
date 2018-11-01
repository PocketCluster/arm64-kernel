#!/usr/bin/env bash

set -x

export PATCH_KERNEL_WIREGUARD=${PATCH_KERNEL_WIREGUARD:-0}

# --- Download Main Kernel ---
if [[ ! -d "components/linux" ]]; then

    export LINUX_REPO=${LINUX_REPO:-"https://github.com/CallMeFoxie/linux.git"}
    export LINUX_BRANCH=${LINUX_BRANCH:-"v4.14-pine64"}
    export LINUX_COMMIT=${LINUX_COMMIT:-"f0899693d21e15ce32df4d4702f236dfe3e0eba7"}

    pushd ${PWD}
        cd components &&\
        git clone --branch ${LINUX_BRANCH} --depth 1 --single-branch ${LINUX_REPO} linux &&\
        cd linux &&\
        git checkout -q ${LINUX_COMMIT}
    popd

    tar -cvzf "${PWD}/components/linux-src-${LINUX_BRANCH}-${LINUX_COMMIT}.tar.gz" components/linux
fi

# --- Download Wireguard ---
if [[ ${PATCH_KERNEL_WIREGUARD} -eq 1 ]];then
    export WG_REPO=${WG_REPO:-"https://git.zx2c4.com/WireGuard"}
    export WG_BRANCH=${WG_MASTER:-"master"}
    export WG_COMMIT=${WG_VERSION:-"0.0.20181018"}

    pushd ${PWD}
    cd components &&\
    git clone --branch ${WG_BRANCH} --depth 1 --single-branch ${WG_REPO} &&\
    cd linux && ../WireGuard/contrib/kernel-tree/create-patch.sh | patch -p1
    popd

    tar -cvzf "${PWD}/components/WireGuard-src-${WG_BRANCH}-${WG_COMMIT}.tar.gz" components/WireGuard

fi

# apply pre-configured config (aufs + vxlan support)
#cp rpi_wireguard_config linux/.config

#git clone --depth=1 -b master https://github.com/raspberrypi/firmware