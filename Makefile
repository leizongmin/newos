DOCKER_IMAGE_NAME ?= newos
DOCKER_IMAGE_TAG ?= latest

TARGET_DIR ?= $(CURDIR)/target
TARGET_ROOTFS_DIR ?= $(TARGET_DIR)/rootfs
TARGET_ROOTFS_BIN_DIR ?= $(TARGET_DIR)/rootfs/bin

CARGO_TARGET ?= x86_64-unknown-linux-musl
CARGO_BUILD_CMD ?= cargo build --target=$(CARGO_TARGET) --release
RUST_MUSL_CROSS_IMAGE_NAME ?= messense/rust-musl-cross:x86_64-musl

#? get help information
.PHONY: help
help:
	@printf "Usage: make [target]\n"

#? initialize the development environment
.PHONY: init
init:
	@curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
	@rustup target add x86_64-unknown-linux-musl

#? clean target
.PHONY: clean
clean:
	@rm -rf ${TARGET_ROOTFS_DIR}

#? make the docker image
.PHONY: docker-image
docker-image: Dockerfile
	@docker build -t $(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG) .
	@docker images -f="reference=$(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG)"

#? use docker to run the image, must make sure the image is built first
.PHONY: docker-run
docker-run:
	@docker run -it --rm $(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG)

.PHONY: docker-save
docker-save:
	@docker save $(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG) > $(TARGET_DIR)/$(DOCKER_IMAGE_NAME).tar
	@tar -tvf $(TARGET_DIR)/$(DOCKER_IMAGE_NAME).tar

#? all target
.PHONY: all
all: bin
	@$(MAKE) docker-image

#? all binarys
.PHONY: bin
bin: 	$(TARGET_ROOTFS_DIR)/bin/init \
		$(TARGET_ROOTFS_DIR)/bin/coreutils \

#? target directory
$(TARGET_DIR):
	@mkdir -p $@

#? target rootfs directory
$(TARGET_ROOTFS_DIR): $(TARGET_DIR)
	@mkdir -p $@

#? target rootfs/bin directory
$(TARGET_ROOTFS_BIN_DIR): $(TARGET_ROOTFS_DIR)
	@mkdir -p $@

#? the /bin/init binary
$(TARGET_ROOTFS_BIN_DIR)/init: $(TARGET_ROOTFS_BIN_DIR) $(CURDIR)/init
	@cd init && \
		$(CARGO_BUILD_CMD) && \
		cp target/$(CARGO_TARGET)/release/init $(TARGET_ROOTFS_BIN_DIR)
	ls -ahl $@ && ldd $@

#? the /bin/coreutils binary
$(TARGET_ROOTFS_BIN_DIR)/coreutils: $(TARGET_ROOTFS_BIN_DIR)
	docker run -it --rm -v $(CURDIR):$(CURDIR) -w $(CURDIR) \
		-v $(TARGET_DIR)/.cargo-registry:/root/.cargo/registry \
		$(RUST_MUSL_CROSS_IMAGE_NAME) \
		cargo install coreutils --target $(CARGO_TARGET) --root $(TARGET_ROOTFS_DIR)
	ls -ahl $@ && ldd $@
