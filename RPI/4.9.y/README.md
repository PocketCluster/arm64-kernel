# Kernel 4.9.y

Kernel 4.9.y for RPI3 (aarch64) is built in three stages

1. Download Prerequsites : run `dl_preq.sh` and it will download kernel source, aufs extension, kernel configuration, and precompiled essetial 32bit boot files from <https://github.com/raspberrypi/firmware> and <https://github.com/Hexxeh/rpi-firmware> (We don't compile them ourselves for now)
2. Containerized Build : run `make` to build with container.
3. Access the newly build kernel : Take the newly compiled kernel and embed in an root file system. Re-iterate manually with `depmod` if module optimization is required.
