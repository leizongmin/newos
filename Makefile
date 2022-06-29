#? docker image name and tag
DOCKER_IMAGE_NAME ?= newos
DOCKER_IMAGE_TAG ?= latest

#? target directory
TARGET_DIR ?= $(CURDIR)/target
TARGET_ROOTFS_DIR ?= $(TARGET_DIR)/rootfs
TARGET_ROOTFS_BIN_DIR ?= $(TARGET_DIR)/rootfs/bin
TARGET_ROOTFS_LIB_DIR ?= $(TARGET_DIR)/rootfs/lib
TARGET_ROOTFS_LIB64_DIR ?= $(TARGET_DIR)/rootfs/lib64

#? cargo target
CARGO_TARGET ?= x86_64-unknown-linux-musl
CARGO_BUILD_CMD ?= cargo build --target=$(CARGO_TARGET) --release
RUST_MUSL_CROSS_IMAGE_NAME ?= messense/rust-musl-cross:x86_64-musl
RUST_MUSL_CROSS_DOCKER_CMD ?= @docker run --rm \
								-v $(CURDIR):$(CURDIR) \
								-w $(CURDIR) \
								-v $(TARGET_DIR)/.cargo-registry:/root/.cargo/registry \
								$(RUST_MUSL_CROSS_IMAGE_NAME)

#? docker gcc
GCC_IMAGE_NAME ?= gcc:12
GCC_DOCKER_CMD ?= @docker run --rm \
					-v $(CURDIR):$(CURDIR) \
					-w $(CURDIR) \
					$(GCC_IMAGE_NAME)

ifeq ($(shell uname -s),Linux)
	CPU_NUMBER ?= $(shell nproc)
else
	CPU_NUMBER ?= 1
endif

################################################################################
#? get help information
.PHONY: help
help:
	@printf "Usage: make [target]\n"

#? setup the development environment
.PHONY: setup
setup:
	@curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
	@rustup target add x86_64-unknown-linux-musl

#? clean target
.PHONY: clean
clean:
	@$(GCC_DOCKER_CMD) bash -c "rm -rf ${TARGET_ROOTFS_DIR}"

################################################################################
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

################################################################################
#? all target
.PHONY: all
all: rootfs
	@$(MAKE) docker-image

#? make the rootfs
.PHONY: rootfs
rootfs: bin libc

#? all binarys
.PHONY: bin
bin: 	init \
		coreutils \
		nushell \
		git \
		ldd \
		bash \

################################################################################
#? target directory
$(TARGET_DIR):
	@if [ ! -d "$@" ]; then mkdir -p $@; fi

#? target rootfs directory
$(TARGET_ROOTFS_DIR): $(TARGET_DIR)
	@if [ ! -d "$@" ]; then mkdir -p $@; fi

#? target rootfs/bin directory
$(TARGET_ROOTFS_BIN_DIR): $(TARGET_ROOTFS_DIR)
	@if [ ! -d "$@" ]; then mkdir -p $@; fi

#? target rootfs/lib directory
$(TARGET_ROOTFS_LIB_DIR): $(TARGET_ROOTFS_DIR)
	@if [ ! -d "$@" ]; then mkdir -p $@; fi

#? target rootfs/lib64 directory
$(TARGET_ROOTFS_LIB64_DIR): $(TARGET_ROOTFS_DIR)
	@if [ ! -d "$@" ]; then mkdir -p $@; fi

################################################################################
#? the /bin/init binary
$(TARGET_ROOTFS_BIN_DIR)/init: $(TARGET_ROOTFS_BIN_DIR) $(CURDIR)/init
	@$(RUST_MUSL_CROSS_DOCKER_CMD) bash -c "cd init && \
		$(CARGO_BUILD_CMD) && \
		cp target/$(CARGO_TARGET)/release/init $(TARGET_ROOTFS_BIN_DIR)"
	@ls -ahl $@ && file $@

.PHONY: init
init: $(TARGET_ROOTFS_BIN_DIR)/init

################################################################################
#? the /bin/coreutils binary
$(TARGET_ROOTFS_BIN_DIR)/coreutils: $(TARGET_ROOTFS_BIN_DIR)
	@$(RUST_MUSL_CROSS_DOCKER_CMD) \
		cargo install coreutils --target $(CARGO_TARGET) --root $(TARGET_ROOTFS_DIR)
	@ls -ahl $@ && file $@

#? the coreutils (cat, cp, cut, pwd, ...) binary
.PHONY: coreutils
coreutils: $(TARGET_ROOTFS_BIN_DIR)/coreutils
	@cp -Rf $(CURDIR)/coreutils/* $(TARGET_ROOTFS_BIN_DIR)

################################################################################
#? the nushell release tar file
$(TARGET_DIR)/nu.tar.gz: $(TARGET_DIR)
	curl -L -o $@ https://github.com/nushell/nushell/releases/download/0.64.0/nu-0.64.0-x86_64-unknown-linux-musl.tar.gz

#? the /bin/nu binary
$(TARGET_ROOTFS_BIN_DIR)/nu: $(TARGET_ROOTFS_BIN_DIR) $(TARGET_DIR)/nu.tar.gz
	@cd $(TARGET_ROOTFS_BIN_DIR) && \
		tar -xvf $(TARGET_DIR)/nu.tar.gz && \
		rm -rf README.* LICENSE nu_plugin_example
	@ls -ahl $@ && file $@

.PHONY: nushell
nushell: $(TARGET_ROOTFS_BIN_DIR)/nu

################################################################################
#? the git release tar file
$(TARGET_DIR)/git.tar.gz: $(TARGET_DIR)
	@curl -L -o $@ https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.37.0.tar.gz

#? the git binary
$(TARGET_ROOTFS_BIN_DIR)/git: $(TARGET_ROOTFS_BIN_DIR) $(TARGET_DIR)/git.tar.gz
	@mkdir -p $(TARGET_DIR)/git && \
		cd $(TARGET_DIR)/git && \
		tar -xvf $(TARGET_DIR)/git.tar.gz --strip-components 1
	$(GCC_DOCKER_CMD) bash -c \
		"cd $(TARGET_DIR)/git && ./configure && make git -j$(CPU_NUMBER)"
	@cp $(TARGET_DIR)/git/git $@
	@ls -ahl $@ && file $@

.PHONY: git
git: $(TARGET_ROOTFS_BIN_DIR)/git

################################################################################
#? the libc
.PHONY: libc
libc: $(TARGET_ROOTFS_LIB_DIR) $(TARGET_ROOTFS_LIB64_DIR)
	$(GCC_DOCKER_CMD) bash -c \
		"cd $(TARGET_ROOTFS_LIB_DIR) && \
		mkdir -p x86_64-linux-gnu && \
		cp -Rf /lib/x86_64-linux-gnu . && \
		cd $(TARGET_ROOTFS_LIB64_DIR) && \
		cp -Rf /lib64/* $(TARGET_ROOTFS_LIB64_DIR)"

#? ldd binary
$(TARGET_ROOTFS_BIN_DIR)/ldd: $(TARGET_ROOTFS_BIN_DIR)
	$(GCC_DOCKER_CMD) bash -c "cp -Rf /usr/bin/ldd $@"
	@ls -ahl $@ && file $@

.PHONY: ldd
ldd: $(TARGET_ROOTFS_BIN_DIR)/ldd

################################################################################
#? the bash release tar file
$(TARGET_DIR)/bash.tar.gz: $(TARGET_DIR)
	@curl -L -o $@ https://ftp.gnu.org/gnu/bash/bash-5.1.tar.gz

#? the bash binary
$(TARGET_ROOTFS_BIN_DIR)/bash: $(TARGET_ROOTFS_BIN_DIR) $(TARGET_DIR)/bash.tar.gz
	@mkdir -p $(TARGET_DIR)/bash && \
		cd $(TARGET_DIR)/bash && \
		tar -xvf $(TARGET_DIR)/bash.tar.gz --strip-components 1
	$(GCC_DOCKER_CMD) bash -c \
		"cd $(TARGET_DIR)/bash && ./configure && make bash -j$(CPU_NUMBER)"
	@cp $(TARGET_DIR)/bash/bash $@
	@ls -ahl $@ && file $@

.PHONY: bash
bash: $(TARGET_ROOTFS_BIN_DIR)/bash

################################################################################
