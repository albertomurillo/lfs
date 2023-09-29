M4_VER := 1.4.19
M4_SRC := https://ftp.gnu.org/gnu/m4/m4-$(M4_VER).tar.xz
M4_TAR := $(SOURCES)/$(notdir $(M4_SRC))
M4_DIR := $(basename $(basename $(M4_TAR)))

.PHONY: m4
m4: $(M4_TAR) $(M4_DIR) $(M4_DIR)/Makefile $(USRBIN)/m4

$(USRBIN)/m4:
	cd $(M4_DIR) \
	&& $(MAKE) \
	&& $(MAKE) DESTDIR=$(ROOT) install

$(M4_DIR)/Makefile:
	cd $(M4_DIR) \
	&& ./configure \
		--prefix=/usr \
	        --host=$(LFS_TGT) \
	        --build=$(shell $(M4_DIR)/build-aux/config.guess)

$(M4_DIR):
	$(UNTAR) $(M4_TAR)

$(M4_TAR):
	$(WGET) $(M4_SRC)
