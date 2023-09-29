GAWK_VER := 5.2.2
GAWK_SRC := https://ftp.gnu.org/gnu/gawk/gawk-$(GAWK_VER).tar.xz
GAWK_TAR := $(SOURCES)/$(notdir $(GAWK_SRC))
GAWK_DIR := $(basename $(basename $(GAWK_TAR)))

.PHONY: gawk
gawk: $(GAWK_TAR) $(GAWK_DIR) $(GAWK_DIR)/Makefile $(USRBIN)/gawk

$(USRBIN)/gawk:
	cd $(GAWK_DIR) \
	&& $(MAKE) \
	&& $(MAKE) DESTDIR=$(ROOT) install

$(GAWK_DIR)/Makefile:
	sed -i 's/extras//' $(GAWK_DIR)/Makefile.in
	cd $(GAWK_DIR) \
	&& ./configure \
		--prefix=/usr \
	        --host=$(LFS_TGT) \
	        --build=$(shell $(GAWK_DIR)/build-aux/config.guess)

$(GAWK_DIR):
	$(UNTAR) $(GAWK_TAR)

$(GAWK_TAR):
	$(WGET) $(GAWK_SRC)
