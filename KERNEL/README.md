# Kernel Compile  

We need to build custom kernel for each board to satisfy all the options Docker needs. Further, it will be necessary to build in secure boot that users should not be able to mount file system to open up what's inside.

In order to minimize the amount of work required, we'll build a process follows this.

1. Acquire the stock kernel from published, distributed boot image
2. Acquire kernel config

  ```sh
  # if /proc/config.gz is not available
  sudo modprobe configs
  zcat /proc/config.gz
  ```
3. [Check config](https://github.com/docker/docker/blob/master/contrib/check-config.sh) for docker.
4. Combine the two compile options together. Make sure all required are built-in rather than become a module.
5. [Integrate AUFS support](wiki/Installing,-running,-using-docker-on-armhf-(ARMv7)-devices#aufs-integration) (optional as it's still unstable) 
6. Compile kernel.


> References

- <https://github.com/umiddelb/armhf/wiki/How-To-compile-a-custom-Linux-kernel-for-your-ARM-device>