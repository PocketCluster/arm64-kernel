build: | output
	cp -rf ../.git .
	(find . -name ".DS_Store" | xargs rm || true)
	docker build -t c2-kernel64 .
	docker run --name c2-kernel64 -v ${PWD}/linux:/linux -v ${PWD}/output:/output c2-kernel64 /build_kernel.sh
	docker rm c2-kernel64
	rm -rf .git

output:
	mkdir -p $@

buildinfo:
    GIT_BRANCH=$(shell git rev-parse --abbrev-ref HEAD)
    GITSHA1=$(shell git rev-parse --short HEAD)
    DATE:=$(shell date)
    $(shell echo "${GIT_BRANCH} : ${GITSHA1} - ${DATE}" > c2-kernel64.info)

clean:
	rm -rf output
	docker rm c2-kernel64
	docker rmi c2-kernel64

.PHONY: build
