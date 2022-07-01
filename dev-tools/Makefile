IMAGE_NAME ?= newos-build

.PHONY: all
all: image

.PHONY: image
image:
	docker build -t $(IMAGE_NAME) -f build_Dockerfile .

.PHONY: shell
shell:
	docker run -it --rm \
		-v $(shell pwd):$(shell pwd) \
		-w $(shell pwd) \
		$(IMAGE_NAME) \
		fish -l
