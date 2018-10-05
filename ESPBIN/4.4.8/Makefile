build: | output
	cp -rf ../../.git .
	(find . -name ".DS_Store" | xargs rm || true)
	docker build -t espbin .
	docker run --name espbin -v ${PWD}/linux-marvell:/linux -v ${PWD}/output:/output espbin /build_kernel.sh
	docker rm espbin
	rm -rf .git

output:
	mkdir -p $@

buildinfo:
    GIT_BRANCH=$(shell git rev-parse --abbrev-ref HEAD)
    GITSHA1=$(shell git rev-parse --short HEAD)
    DATE:=$(shell date)
    $(shell echo "${GIT_BRANCH} : ${GITSHA1} - ${DATE}" > espbin.info)

clean:
	rm -rf output
	docker rm espbin
	docker rmi espbin

.PHONY: build
