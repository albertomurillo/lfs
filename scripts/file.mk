FILE_VER := 5.45
FILE_SRC := https://astron.com/pub/file/file-$(FILE_VER).tar.gz
FILE_TAR := $(SOURCES)/$(notdir $(FILE_SRC))
FILE_DIR := $(basename $(basename $(FILE_TAR)))

.PHONY: file
file: $(FILE_TAR) $(FILE_DIR) $(FILE_DIR)/build/Makefile $(USRBIN)/file

$(USRBIN)/file:
	cd $(FILE_DIR)/build \
	&& $(MAKE)

	cd $(FILE_DIR)/ \
	&& ./configure \
		--prefix=/usr \
		--host=$(LFS_TGT) \
		--build=$(shell $(FILE_DIR)/config.guess)

	cd $(FILE_DIR)/ \
	&& $(MAKE) FILE_COMPILE=$(abspath $(FILE_DIR)/build/src/file) \
	&& $(MAKE) DESTDIR=$(ROOT) install \
	&& $(RM) $(USRLIB)/libmagic.la

$(FILE_DIR)/build/Makefile:
	mkdir -p $(FILE_DIR)/build
	cd $(FILE_DIR)/build \
	&& ../configure \
		--disable-bzlib \
		--disable-libseccomp \
		--disable-xzlib \
		--disable-zlib

$(FILE_DIR):
	$(UNTAR) $(FILE_TAR)

$(FILE_TAR):
	$(WGET) $(FILE_SRC)
