ROOT_DIR ?= $(shell realpath $(CURDIR)/../..)
DIST_DIR ?= $(ROOT_DIR)/dist
CARGO_CACHE_DIR ?= $(ROOT_DIR)/.cache/cargo
SOURCE_DIR ?= $(CURDIR)/source
TARGET_DIR ?= $(CURDIR)/target
CARGO_TARGET ?= x86_64-unknown-linux-musl
CARGO_BUILD_CMD ?= cargo build --target=$(CARGO_TARGET) --release --manifest-path=$(SOURCE_DIR)/Cargo.toml --target-dir=$(TARGET_DIR)
RUST_MUSL_CROSS_IMAGE_NAME ?= messense/rust-musl-cross:x86_64-musl
RUST_MUSL_CROSS_DOCKER_CMD ?= docker run --rm -it \
								-v $(ROOT_DIR):$(ROOT_DIR) \
								-w $(CURDIR) \
								-v $(CARGO_CACHE_DIR):/root/.cargo/registry \
								$(RUST_MUSL_CROSS_IMAGE_NAME)

.PHONY: all
all: coreutils dist

.PHONY: coreutils
coreutils:
	mkdir -p $(CARGO_CACHE_DIR)
	$(RUST_MUSL_CROSS_DOCKER_CMD) $(CARGO_BUILD_CMD)

.PHONY: dist
dist:
	mkdir -p $(DIST_DIR)/bin
	cp $(TARGET_DIR)/$(CARGO_TARGET)/release/coreutils $(DIST_DIR)/bin
