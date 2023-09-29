DIFFUTILS_VER := 3.10
DIFFUTILS_SRC := https://ftp.gnu.org/gnu/diffutils/diffutils-$(DIFFUTILS_VER).tar.xz
DIFFUTILS_TAR := $(SOURCES)/$(notdir $(DIFFUTILS_SRC))
DIFFUTILS_DIR := $(basename $(basename $(DIFFUTILS_TAR)))

.PHONY: diffutils
diffutils: $(DIFFUTILS_TAR) $(DIFFUTILS_DIR) $(DIFFUTILS_DIR)/Makefile $(USRBIN)/diff

$(USRBIN)/diff:
	cd $(DIFFUTILS_DIR) \
	&& $(MAKE) \
	&& $(MAKE) DESTDIR=$(ROOT) install

$(DIFFUTILS_DIR)/Makefile:
	cd $(DIFFUTILS_DIR) \
	&& ./configure \
		--prefix=/usr \
	        --host=$(LFS_TGT) \
	        --build=$(shell $(DIFFUTILS_DIR)/build-aux/config.guess)

$(DIFFUTILS_DIR):
	$(UNTAR) $(DIFFUTILS_TAR)

$(DIFFUTILS_TAR):
	$(WGET) $(DIFFUTILS_SRC)
