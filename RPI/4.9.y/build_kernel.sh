#!/usr/bin/env bash

export CROSS_COMPILE=aarch64-linux-gnu-
export ARCH=arm64
export JOBS=$(nproc)
	
cd /linux 

if [[ ! -f .config ]]; then

	make -j${JOBS} ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- bcmrpi3_defconfig
	# make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- menuconfig
	: <<'AUFS_CFG_ADDED'
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
AUFS_CFG_ADDED

	# following config options is for docker
	: <<'DOCKER_CFG_ADDED'
125c125,126
< # CONFIG_MEMCG_SWAP is not set
---
> CONFIG_MEMCG_SWAP=y
> CONFIG_MEMCG_SWAP_ENABLED=y
131,133c132,134
< # CONFIG_CFS_BANDWIDTH is not set
< # CONFIG_RT_GROUP_SCHED is not set
< # CONFIG_CGROUP_PIDS is not set
---
> CONFIG_CFS_BANDWIDTH=y
> CONFIG_RT_GROUP_SCHED=y
> CONFIG_CGROUP_PIDS=y
139c140
< # CONFIG_CGROUP_PERF is not set
---
> CONFIG_CGROUP_PERF=y
603c604
< CONFIG_NET_IP_TUNNEL=m
---
> CONFIG_NET_IP_TUNNEL=y
612c613
< CONFIG_NET_UDP_TUNNEL=m
---
> CONFIG_NET_UDP_TUNNEL=y
1102c1103
< # CONFIG_NET_L3_MASTER_DEV is not set
---
> CONFIG_NET_L3_MASTER_DEV=y
1108c1109
< # CONFIG_CGROUP_NET_PRIO is not set
---
> CONFIG_CGROUP_NET_PRIO=y
1676a1678
> CONFIG_IPVLAN=m
1688a1691
> # CONFIG_NET_VRF is not set
DOCKER_CFG_ADDED

fi 

make -j${JOBS} ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- LOCALVERSION="-arm64" Image
make -j${JOBS} ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- LOCALVERSION="-arm64" dtbs
make -j${JOBS} ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- LOCALVERSION="-arm64" modules


mkdir -p /output/RPIROOT/boot
make -j ${JOBS} INSTALL_MOD_PATH=/output/RPIROOT ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- modules_install

cp -rf /linux/arch/arm64/boot/Image /output/RPIROOT/boot/kernel8.img
cp -rf /linux/arch/arm64/boot/dts/broadcom/bcm2710-rpi-3-b.dtb /output/RPIROOT/boot/
cp -rf /linux/arch/arm64/boot/dts/broadcom/bcm2837-rpi-3-b.dtb /output/RPIROOT/boot/
cp -rf /linux/arch/arm/boot/dts/overlays /output/RPIROOT/boot/overlays

rm -rf /output/RPIROOT/boot/overlays/.*.tmp
rm -rf /output/RPIROOT/boot/overlays/.*.cmd
rm -rf /output/RPIROOT/boot/overlays/*.dts

cd /output/RPIROOT && tar -cvzf kernel64-4.9.40.tar.gz *