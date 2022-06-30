ROOT_DIR := $(shell cd $(CURDIR)/../..; pwd)
TARGET_DIR ?= $(ROOT_DIR)/target/base/git
BUILD_IMAGE_NAME ?= messense/rust-musl-cross:x86_64-musl
ifeq ($(shell uname -s),Linux)
	CPU_NUMBER ?= $(shell nproc)
else
	CPU_NUMBER ?= 1
endif

GIT_VERSION ?= $(shell cat $(CURDIR)/VERSION)

.PHONY: all
all: $(TARGET_DIR)/git-$(GIT_VERSION).tar.gz
	@echo ROOT_DIR=$(ROOT_DIR)
	@echo TARGET_DIR=$(TARGET_DIR)
	@echo GIT_VERSION=$(GIT_VERSION)
	@docker run --rm -v $(ROOT_DIR):$(ROOT_DIR) -w $(TARGET_DIR)/source \
		$(BUILD_IMAGE_NAME) \
		bash -c "pwd; ls -ahl; \
			./configure --prefix=$(TARGET_DIR)/build/; \
			make -j$(CPU_NUMBER) NO_OPENSSL=1 NO_CURL=1 CFLAGS="-static"; \
			mkdir -p $(TARGET_DIR)/build/bin; \
				cp -rf git $(TARGET_DIR)/build/bin; \
			mkdir -p $(TARGET_DIR)/build/lib; \
				cp -rf /lib/x86_64-linux-gnu/libcurl-* $(TARGET_DIR)/build/lib; \
				cp -rf /lib/x86_64-linux-gnu/libnghttp2* $(TARGET_DIR)/build/lib; \
				cp -rf /lib/x86_64-linux-gnu/libidn2* $(TARGET_DIR)/build/lib; \
				cp -rf /lib/x86_64-linux-gnu/librtmp* $(TARGET_DIR)/build/lib; \
				cp -rf /lib/x86_64-linux-gnu/libssh* $(TARGET_DIR)/build/lib; \
				cp -rf /lib/x86_64-linux-gnu/libpsl* $(TARGET_DIR)/build/lib; \
				cp -rf /lib/x86_64-linux-gnu/libnettle* $(TARGET_DIR)/build/lib; \
				cp -rf /lib/x86_64-linux-gnu/libgnutls* $(TARGET_DIR)/build/lib; \
				cp -rf /lib/x86_64-linux-gnu/libgssapi* $(TARGET_DIR)/build/lib; \
				cp -rf /lib/x86_64-linux-gnu/libldap* $(TARGET_DIR)/build/lib; \
				cp -rf /lib/x86_64-linux-gnu/liblber* $(TARGET_DIR)/build/lib; \
				cp -rf /lib/x86_64-linux-gnu/libbrotli* $(TARGET_DIR)/build/lib; \
				cp -rf /lib/x86_64-linux-gnu/libunistring* $(TARGET_DIR)/build/lib; \
				cp -rf /lib/x86_64-linux-gnu/libhogweed* $(TARGET_DIR)/build/lib; \
				cp -rf /lib/x86_64-linux-gnu/libgmp* $(TARGET_DIR)/build/lib; \
				cp -rf /lib/x86_64-linux-gnu/libcrypto* $(TARGET_DIR)/build/lib; \
				cp -rf /lib/x86_64-linux-gnu/libp11-kit* $(TARGET_DIR)/build/lib; \
				cp -rf /lib/x86_64-linux-gnu/libtasn1* $(TARGET_DIR)/build/lib; \
				cp -rf /lib/x86_64-linux-gnu/libkrb5* $(TARGET_DIR)/build/lib; \
				cp -rf /lib/x86_64-linux-gnu/libk5crypto* $(TARGET_DIR)/build/lib; \
				cp -rf /lib/x86_64-linux-gnu/libsasl2* $(TARGET_DIR)/build/lib; \
				cp -rf /lib/x86_64-linux-gnu/libffi* $(TARGET_DIR)/build/lib; \
				cp -rf /lib/x86_64-linux-gnu/libheimntlm* $(TARGET_DIR)/build/lib; \
				cp -rf /lib/x86_64-linux-gnu/libasn1* $(TARGET_DIR)/build/lib; \
				cp -rf /lib/x86_64-linux-gnu/libhcrypto* $(TARGET_DIR)/build/lib; \
				cp -rf /lib/x86_64-linux-gnu/libroken* $(TARGET_DIR)/build/lib; \
				cp -rf /lib/x86_64-linux-gnu/libwind* $(TARGET_DIR)/build/lib; \
				cp -rf /lib/x86_64-linux-gnu/libheimbase* $(TARGET_DIR)/build/lib; \
				cp -rf /lib/x86_64-linux-gnu/libhx509* $(TARGET_DIR)/build/lib; \
				cp -rf /lib/x86_64-linux-gnu/libsqlite3* $(TARGET_DIR)/build/lib; \
			"
	@ls -ahl $(TARGET_DIR)/build

$(TARGET_DIR):
	@if [ ! -d $(TARGET_DIR) ]; then mkdir -p $(TARGET_DIR); fi
	@if [ ! -d $(TARGET_DIR)/build ]; then mkdir -p $(TARGET_DIR)/build; fi
	@if [ ! -d $(TARGET_DIR)/source ]; then mkdir -p $(TARGET_DIR)/source; fi

$(TARGET_DIR)/git-$(GIT_VERSION).tar.gz: $(TARGET_DIR)
	@curl -L -o $@ https://mirrors.edge.kernel.org/pub/software/scm/git/git-$(GIT_VERSION).tar.gz
	@ls -ahl $@ && file $@
	@tar -xf $@ -C $(TARGET_DIR)/source --strip-components 1

.PHONY: clean
clean:
	@rm -rf $(TARGET_DIR)
