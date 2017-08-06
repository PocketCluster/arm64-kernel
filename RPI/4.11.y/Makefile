build: | output
	cp -rf ../.git .
	(find . -name ".DS_Store" | xargs rm || true)
	docker build -t rpi-kernel64 .
	docker run --name rpi-kernel64 -v ${PWD}/linux:/linux -v ${PWD}/output:/output rpi-kernel64 /build_kernel.sh
	docker rm rpi-kernel64
	rm -rf .git

output:
	mkdir -p $@

buildinfo:
    GIT_BRANCH=$(shell git rev-parse --abbrev-ref HEAD)
    GITSHA1=$(shell git rev-parse --short HEAD)
    DATE:=$(shell date)
    $(shell echo "${GIT_BRANCH} : ${GITSHA1} - ${DATE}" > rpi-kernel64.info)

clean:
	rm -rf output
	docker rm rpi-kernel64
	docker rmi rpi-kernel64

.PHONY: build
