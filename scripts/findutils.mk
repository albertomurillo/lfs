FINDUTILS_VER := 4.9.0
FINDUTILS_SRC := https://ftp.gnu.org/gnu/findutils/findutils-$(FINDUTILS_VER).tar.xz
FINDUTILS_TAR := $(SOURCES)/$(notdir $(FINDUTILS_SRC))
FINDUTILS_DIR := $(basename $(basename $(FINDUTILS_TAR)))

.PHONY: findutils
findutils: $(FINDUTILS_TAR) $(FINDUTILS_DIR) $(FINDUTILS_DIR)/Makefile $(USRBIN)/find

$(USRBIN)/find:
	cd $(FINDUTILS_DIR) \
	&& $(MAKE) \
	&& $(MAKE) DESTDIR=$(ROOT) install

$(FINDUTILS_DIR)/Makefile:
	cd $(FINDUTILS_DIR) \
	&& ./configure \
		--prefix=/usr \
		--localstatedir=/var/lib/locate \
		--host=$(LFS_TGT) \
		--build=$(shell $(FINDUTILS_DIR)/build-aux/config.guess)

$(FINDUTILS_DIR):
	$(UNTAR) $(FINDUTILS_TAR)

$(FINDUTILS_TAR):
	$(WGET) $(FINDUTILS_SRC)
