PATCH_VER := 2.7.6
PATCH_SRC := https://ftp.gnu.org/gnu/patch/patch-$(PATCH_VER).tar.xz
PATCH_TAR := $(SOURCES)/$(notdir $(PATCH_SRC))
PATCH_DIR := $(basename $(basename $(PATCH_TAR)))

.PHONY: patch
patch: $(PATCH_TAR) $(PATCH_DIR) $(PATCH_DIR)/Makefile $(USRBIN)/patch

$(USRBIN)/patch:
	cd $(PATCH_DIR) \
	&& $(MAKE) \
	&& $(MAKE) DESTDIR=$(ROOT) install

$(PATCH_DIR)/Makefile:
	cd $(PATCH_DIR) \
	&& ./configure \
		--prefix=/usr \
		--host=$(LFS_TGT) \
		--build=$(shell $(PATCH_DIR)/build-aux/config.guess)
$(PATCH_DIR):
	$(UNTAR) $(PATCH_TAR)

$(PATCH_TAR):
	$(WGET) $(PATCH_SRC)
