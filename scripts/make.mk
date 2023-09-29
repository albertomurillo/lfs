MAKE_VER := 4.4.1
MAKE_SRC := https://ftp.gnu.org/gnu/make/make-$(MAKE_VER).tar.gz
MAKE_TAR := $(SOURCES)/$(notdir $(MAKE_SRC))
MAKE_DIR := $(basename $(basename $(MAKE_TAR)))

.PHONY: make
make: $(MAKE_TAR) $(MAKE_DIR) $(MAKE_DIR)/Makefile $(USRBIN)/make

$(USRBIN)/make:
	cd $(MAKE_DIR) \
	&& $(MAKE) \
	&& $(MAKE) DESTDIR=$(ROOT) install

$(MAKE_DIR)/Makefile:
	cd $(MAKE_DIR) \
	&& ./configure \
		--prefix=/usr \
		--without-guile \
		--host=$(LFS_TGT) \
		--build=$(shell $(MAKE_DIR)/build-aux/config.guess)
$(MAKE_DIR):
	$(UNTAR) $(MAKE_TAR)

$(MAKE_TAR):
	$(WGET) $(MAKE_SRC)
