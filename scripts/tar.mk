TAR_VER := 1.35
TAR_SRC := https://ftp.gnu.org/gnu/tar/tar-$(TAR_VER).tar.xz
TAR_TAR := $(SOURCES)/$(notdir $(TAR_SRC))
TAR_DIR := $(basename $(basename $(TAR_TAR)))

.PHONY: tar
tar: $(TAR_TAR) $(TAR_DIR) $(TAR_DIR)/Makefile $(USRBIN)/tar

$(USRBIN)/tar:
	cd $(TAR_DIR) \
	&& $(MAKE) \
	&& $(MAKE) DESTDIR=$(ROOT) install

$(TAR_DIR)/Makefile:
	cd $(TAR_DIR) \
	&& ./configure \
		--prefix=/usr \
		--host=$(LFS_TGT) \
		--build=$(shell $(TAR_DIR)/build-aux/config.guess)
$(TAR_DIR):
	$(UNTAR) $(TAR_TAR)

$(TAR_TAR):
	$(WGET) $(TAR_SRC)
