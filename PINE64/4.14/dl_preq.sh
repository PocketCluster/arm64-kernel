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

# --- Download & Patch Wireguard ---
if [[ ${PATCH_KERNEL_WIREGUARD} -eq 1 ]];then
    export WG_REPO=${WG_REPO:-"https://git.zx2c4.com/WireGuard"}
    export WG_BRANCH=${WG_BRANCH:-"master"}
    export WG_COMMIT=${WG_COMMIT:-"0.0.20181018"}

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


# --- Download Busybox ---
if [[ ! -d "components/busybox" ]]; then
    export BB_REPO=${BB_REPO:-"git://git.busybox.net/busybox"}
    export BB_BRANCH=${BB_BRANCH:-"1_29_stable"}
    export BB_COMMIT=${BB_COMMIT:-"b84194b133212aca64605d1cd0cf771720bc0d94"}

    pushd ${PWD}
        cd components &&\
        git clone --branch ${BB_BRANCH} --depth 1 --single-branch ${BB_REPO} &&\
        cd busybox &&\
        git checkout -q ${BB_COMMIT}
    popd

    tar -cvzf "${PWD}/components/busybox-src-${BB_BRANCH}-${BB_COMMIT}.tar.gz" components/busybox
fi

# --- Download arm-trusted-firmware.git ---
if [[ ! -d "components/arm-trusted-firmware" ]]; then
    export FW_REPO=${FW_REPO:-"https://github.com/ARM-software/arm-trusted-firmware.git"}
    export FW_BRANCH=${FW_BRANCH:-"master"}
    export FW_COMMIT=${FW_COMMIT:-"dbc8d9496ead9ecdd7c2a276b542a4fbbbf64027"} # V2.0 2018/10/03

    pushd ${PWD}
        cd components &&\
        git clone --branch ${FW_BRANCH} --depth 1 --single-branch ${FW_REPO} &&\
        cd arm-trusted-firmware &&\
        git checkout -q ${FW_COMMIT}
    popd

    tar -cvzf "${PWD}/components/arm-trusted-firmware-src-${FW_BRANCH}-${FW_COMMIT}.tar.gz" components/arm-trusted-firmware
fi


# --- Download u-boot ---
if [[ ! -d "components/u-boot" ]]; then
    export UB_REPO=${UB_REPO:-"https://github.com/u-boot/u-boot.git"}
    export UB_BRANCH=${UB_BRANCH:-"master"}
    export UB_COMMIT=${UB_COMMIT:-"454cf76184c65426b68033a23da086e73663f2fc"} # V2.0 2018/10/03

    pushd ${PWD}
        cd components &&\
        git clone --branch ${UB_BRANCH} --depth 1 --single-branch ${UB_REPO} &&\
        cd u-boot &&\
        git checkout -q ${UB_COMMIT}
    popd

    tar -cvzf "${PWD}/components/u-boot-src-${UB_BRANCH}-${UB_COMMIT}.tar.gz" components/u-boot
fi
