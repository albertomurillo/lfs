XZ_VER := 5.4.4
XZ_SRC := https://tukaani.org/xz/xz-$(XZ_VER).tar.xz
XZ_TAR := $(SOURCES)/$(notdir $(XZ_SRC))
XZ_DIR := $(basename $(basename $(XZ_TAR)))

.PHONY: xz
xz: $(XZ_TAR) $(XZ_DIR) $(XZ_DIR)/Makefile $(USRBIN)/xz

$(USRBIN)/xz:
	cd $(XZ_DIR) \
	&& $(MAKE) \
	&& $(MAKE) DESTDIR=$(ROOT) install \
	&& $(RM) $(USRLIB)/liblzma.la

$(XZ_DIR)/Makefile:
	cd $(XZ_DIR) \
	&& ./configure \
		--prefix=/usr \
	        --host=$(LFS_TGT) \
	        --build=$(shell $(XZ_DIR)/build-aux/config.guess) \
		--disable-static \
		--docdir=/usr/share/doc/xz-$(XZ_VER)
$(XZ_DIR):
	$(UNTAR) $(XZ_TAR)

$(XZ_TAR):
	$(WGET) $(XZ_SRC)
