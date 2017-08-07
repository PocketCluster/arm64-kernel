#!/usr/bin/env bash

set -x

git clone --depth=1 -b rpi-4.11.y https://github.com/raspberrypi/linux.git

#git clone --depth=1 -b master https://github.com/raspberrypi/firmware