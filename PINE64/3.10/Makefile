build: | output
	(find . -name ".DS_Store" | xargs rm || true)
	docker build -t pine64-kernel .
	docker run --name pine64-kernel -v ${PWD}/linux-pine64:/linux -v ${PWD}/output:/output pine64-kernel bash /build_kernel.sh
	docker rm pine64-kernel
	cd output && tar cvzf ../pine64-3.10.105.tar.gz *

output:
	(rm -rf ${PWD}/output || true)
	mkdir -p $@

clean:
	rm -rf output
	docker rm pine64-kernel
	docker rmi pine64-kernel

.PHONY: build
