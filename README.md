# ARM64 Kernel Builder

- Raspberry PI
- Pine64

## Kernel Options Configuration

- Search a target option  
  ![](search.png)
- Enable/Disable or make it module
  ![](ipvlan.png)
- Make sure Depedencies are also checked and enabled

**In these way, we can build a proper custom configuration w/ dependency for kernel build**

## Manual Docker Run

```sh
docker ps --filter "status=exited" | awk '{print $1}' | xargs --no-run-if-empty docker rm
docker run -it --name rpi-kernel64 -v ${PWD}/linux:/linux -v ${PWD}/output:/output rpi-kernel64 /bin/bash
```

