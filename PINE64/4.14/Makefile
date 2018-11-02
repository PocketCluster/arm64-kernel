clean:
	rm -rf output
	docker rm pine64-compile
	docker rmi pine64-compile

output:
	(find . -name ".DS_Store" | xargs rm || true)
	mkdir -p $@

docker:
	docker build -t pine64-compile .

kernel:
	docker run \
		--rm \
		--name pine64-compile \
		-v ${PWD}/config:/config \
		-v ${PWD}/script:/script \
		-v ${PWD}/output:/output \
		-v ${PWD}/components/linux:/linux \
		pine64-compile bash /script/build_kernel.sh

busybox:
	docker run \
		--rm \
		--name pine64-compile \
		-v ${PWD}/config:/config \
		-v ${PWD}/script:/script \
		-v ${PWD}/output:/output \
		-v ${PWD}/components/busybox:/busybox \
		pine64-compile bash /script/build_busybox.sh

uboot:
	docker run \
		--rm \
		--name pine64-compile \
		-v ${PWD}/config:/config \
		-v ${PWD}/script:/script \
		-v ${PWD}/output:/output \
		-v ${PWD}/components/arm-trusted-firmware:/arm-trusted-firmware \
		-v ${PWD}/components/u-boot:/u-boot \
		pine64-compile bash /script/build_uboot.sh

#.PHONY: build
