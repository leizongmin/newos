#? docker image name and tag
DOCKER_IMAGE_NAME ?= newos
DOCKER_IMAGE_TAG ?= latest

#? target directory
TARGET_DIR ?= $(CURDIR)/target
TARGET_ROOTFS_DIR ?= $(TARGET_DIR)/rootfs
TARGET_ROOTFS_BIN_DIR ?= $(TARGET_DIR)/rootfs/bin

#? cargo target
CARGO_TARGET ?= x86_64-unknown-linux-musl
CARGO_BUILD_CMD ?= cargo build --target=$(CARGO_TARGET) --release
RUST_MUSL_CROSS_IMAGE_NAME ?= messense/rust-musl-cross:x86_64-musl
RUST_MUSL_CROSS_DOCKER_CMD ?= @docker run --rm \
								-v $(CURDIR):$(CURDIR) \
								-w $(CURDIR) \
								-v $(TARGET_DIR)/.cargo-registry:/root/.cargo/registry \
								$(RUST_MUSL_CROSS_IMAGE_NAME)

#? get help information
.PHONY: help
help:
	@printf "Usage: make [target]\n"

#? initialize the development environment
.PHONY: init
init:
	@curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
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
	@docker run -it --rm -e RUST_BACKTRACE=full $(DOCKER_IMAGE_NAME):$(DOCKER_IMAGE_TAG)

#? save the docker image to a tarball
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
		coreutils \
		$(TARGET_ROOTFS_BIN_DIR)/nu \

#? target directory
$(TARGET_DIR):
	@if [ ! -d "$@" ]; then mkdir -p $@; fi

#? target rootfs directory
$(TARGET_ROOTFS_DIR): $(TARGET_DIR)
	@if [ ! -d "$@" ]; then mkdir -p $@; fi

#? target rootfs/bin directory
$(TARGET_ROOTFS_BIN_DIR): $(TARGET_ROOTFS_DIR)
	@if [ ! -d "$@" ]; then mkdir -p $@; fi

#? the /bin/init binary
$(TARGET_ROOTFS_BIN_DIR)/init: $(TARGET_ROOTFS_BIN_DIR) $(CURDIR)/init
	@$(RUST_MUSL_CROSS_DOCKER_CMD) bash -c "cd init && \
		$(CARGO_BUILD_CMD) && \
		cp target/$(CARGO_TARGET)/release/init $(TARGET_ROOTFS_BIN_DIR)"
	@ls -ahl $@ && file $@

#? the /bin/coreutils binary
$(TARGET_ROOTFS_BIN_DIR)/coreutils: $(TARGET_ROOTFS_BIN_DIR)
	@$(RUST_MUSL_CROSS_DOCKER_CMD) \
		cargo install coreutils --target $(CARGO_TARGET) --root $(TARGET_ROOTFS_DIR)
	@ls -ahl $@ && file $@

#? the coreutils (cat, cp, cut, pwd, ...) binary
.PHONY: coreutils
coreutils: $(TARGET_ROOTFS_BIN_DIR)/coreutils
	@cp -Rf $(CURDIR)/coreutils/* $(TARGET_ROOTFS_BIN_DIR)

#? the nushell release tar file
$(TARGET_DIR)/nu.tar.gz:
	curl -L -o $(TARGET_DIR)/nu.tar.gz https://github.com/nushell/nushell/releases/download/0.64.0/nu-0.64.0-x86_64-unknown-linux-musl.tar.gz

#? the /bin/nu binary
$(TARGET_ROOTFS_BIN_DIR)/nu: $(TARGET_ROOTFS_BIN_DIR) $(TARGET_DIR)/nu.tar.gz
	@cd $(TARGET_ROOTFS_BIN_DIR) && \
		tar -xvf $(TARGET_DIR)/nu.tar.gz && \
		rm -rf README.* LICENSE nu_plugin_example
	@ls -ahl $@ && file $@
