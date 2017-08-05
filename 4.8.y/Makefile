build: | output
	(find . -name ".DS_Store" | xargs rm || true)
	docker build -t rpi-kernel64 .
#	docker run -it --name rpi-kernel64 -v ${PWD}/output:/tmp/output pc-core /tmp/make_iso.sh
#	docker cp pc-core:/pc-core.iso ${PWD}/output/
#	docker rm rpi-kernel64
#	docker rmi pc-core

output:
	mkdir -p $@

buildinfo:
    GIT_BRANCH=$(shell git rev-parse --abbrev-ref HEAD)
    GITSHA1=$(shell git rev-parse --short HEAD)
    DATE:=$(shell date)
    $(shell echo "${GIT_BRANCH} : ${GITSHA1} - ${DATE}" > pocketcluster.info)

#clean:
#	rm -rf output
#	-docker rm boot2docker
#	-docker rmi boot2docker

.PHONY: build
