# Kernel 4.9.y

## Manual Option

```sh
docker ps --filter "status=exited" | awk '{print $1}' | xargs --no-run-if-empty docker rm
docker run -it --name rpi-kernel64 -v ${PWD}/linux:/linux -v ${PWD}/output:/output rpi-kernel64 /bin/bash
```