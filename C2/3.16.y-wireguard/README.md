# Kernel 4.9.y-wireguard

Kernel 4.9.y for C2 (aarch64) is built in three stages

1. Download Prerequsites : run `dl_preq.sh` and it will download kernel source, WireGuard source.
2. Containerized Build : run `make` to build with container.
3. Access the newly build kernel : Take the newly compiled kernel and embed in an root file system. Re-iterate manually with `depmod` if module optimization is required.

# Built-In Wireguard Compilation
## Kernel Requirements

WireGuard requires Linux ≥3.10, with the following configuration options, which are likely already configured in your kernel, especially if you're installing via distribution packages, above.

  - `CONFIG_NET` for basic networking support
  - `CONFIG_INET` for basic IP support
  - `CONFIG_NET_UDP_TUNNEL` for sending and receiving UDP packets
  - `CONFIG_CRYPTO_BLKCIPHER` for doing scatter-gather I/O

Corresponding menuconfig entries

```
[*] Networking support -->
    Networking options -->
        [*] TCP/IP networking
        [*]   IP: Foo (IP protocols) over UDP
[*] Cryptographic API -->
    [*] Cryptographic algorithm manager
```

To build WireGuard as built-in, directly from within the kernel tree, you may use the create-patch.sh script which creates a patch for adding WireGuard directly to the tree or the jury-rig.sh script which links the WireGuard source directory into the kernel tree:

```
$ cd /usr/src/linux
$ ~/wireguard/contrib/kernel-tree/create-patch.sh | patch -p1
```

Then you will be able to configure these options directly:

  - `CONFIG_WIREGUARD` controls whether or not WireGuard is built (as a module, as built-in, or not at all)
  - `CONFIG_WIREGUARD_DEBUG` turns on verbose debug messages

These are selectable easily via menuconfig, if CONFIG_NET and CONFIG_INET are also selected:

```
[*] Networking support -->
    Networking options -->
        [*] TCP/IP networking
        [*]   IP: WireGuard secure network tunnel
        [ ]     Debugging checks and verbose messages
        [*] The IPv6 protocol (as Wireguard is dependent)
```

# Install Kernel

```
tar xzf kernel64-3.16.60.tar.gz -C kernel64-3.16.60
cp -rf kernel64-3.16.60/boot/* /boot
rm -rf /lib/firmware && cp -rf kernel64-3.16.60/lib/firmware /lib/
rm -rf /lib/modules/3.16.60-arm64 && cp -rf kernel64-3.16.60/lib/modules/3.16.60-arm64 /lib/modules
rm -rf /usr/src/linux-headers-3.16.60-arm64 && cp -rf kernel64-3.16.60/include /usr/src/linux-headers-3.16.60-arm64
rm /lib/modules/3.16.60-arm64/build && ln -s /usr/src/linux-headers-3.16.60-arm64 /lib/modules/3.16.60-arm64/build
```

# Install WireGuard Tools
(installing WireGuard doesn't require linux header or source)

```
apt-get -y install libmnl-dev libelf-dev build-essential pkg-config kmod

wget https://git.zx2c4.com/WireGuard/snapshot/WireGuard-0.0.20181018.tar.xz 
tar xf WireGuard-0.0.20181018.tar.xz 
cd WireGuard-0.0.20181018/src
```

comment out following line in `MakeFile`
```make
install:
# @$(MAKE) -C $(KERNELDIR) M=$(PWD) modules_install
  depmod -a
  @$(MAKE) -C tools install
```

```
make tools && make install (as root)
```
