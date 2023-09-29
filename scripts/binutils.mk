BINUTILS_VER := 2.41
BINUTILS_SRC := https://sourceware.org/pub/binutils/releases/binutils-$(BINUTILS_VER).tar.xz
BINUTILS_TAR := $(SOURCES)/$(notdir $(BINUTILS_SRC))
BINUTILS_DIR := $(basename $(basename $(BINUTILS_TAR)))

.PHONY:
binutils: $(BINUTILS_TAR) $(BINUTILS_DIR)

$(BINUTILS_DIR):
	$(UNTAR) $(BINUTILS_TAR)

$(BINUTILS_TAR):
	$(WGET) $(BINUTILS_SRC)

.PHONY: binutils-pass1
binutils-pass1: binutils $(BINUTILS_DIR)/pass1/Makefile $(TOOLS)/bin/$(LFS_TGT)-as

$(TOOLS)/bin/$(LFS_TGT)-as:
	cd $(BINUTILS_DIR)/pass1 \
	&& $(MAKE) \
	&& $(MAKE) install

$(BINUTILS_DIR)/pass1/Makefile:
	mkdir -p $(BINUTILS_DIR)/pass1 \
	&& cd $(BINUTILS_DIR)/pass1 \
	&& ../configure \
		--prefix=$(TOOLS) \
		--with-sysroot=$(ROOT) \
		--target=$(LFS_TGT) \
		--disable-nls \
		--enable-gprofng=no \
		--disable-werror

.PHONY: binutils-pass2
binutils-pass2: binutils $(BINUTILS_DIR)/pass2/Makefile $(USRBIN)/as

$(USRBIN)/as:
	cd $(BINUTILS_DIR)/pass2 \
	&& $(MAKE) \
	&& $(MAKE) DESTDIR=$(ROOT) install \
	&& $(RM) $(USRLIB)/lib{bfd,ctf,ctf-nobfd,opcodes,sframe}.{a,la}

$(BINUTILS_DIR)/pass2/Makefile:
	sed '6009s/$$add_dir//' -i $(BINUTILS_DIR)/ltmain.sh

	mkdir -p $(BINUTILS_DIR)/pass2 \
	&& cd $(BINUTILS_DIR)/pass2 \
	&& ../configure \
		--prefix=/usr \
		--build=$(shell $(BINUTILS_DIR)/config.guess) \
		--host=$(LFS_TGT) \
		--disable-nls \
		--enable-shared \
		--enable-gprofng=no \
		--disable-werror \
		--enable-64-bit-bfd
