GZIP_VER := 1.13
GZIP_SRC := https://ftp.gnu.org/gnu/gzip/gzip-$(GZIP_VER).tar.xz
GZIP_TAR := $(SOURCES)/$(notdir $(GZIP_SRC))
GZIP_DIR := $(basename $(basename $(GZIP_TAR)))

.PHONY: gzip
gzip: $(GZIP_TAR) $(GZIP_DIR) $(GZIP_DIR)/Makefile $(USRBIN)/gzip

$(USRBIN)/gzip:
	cd $(GZIP_DIR) \
	&& $(MAKE) \
	&& $(MAKE) DESTDIR=$(ROOT) install

$(GZIP_DIR)/Makefile:
	cd $(GZIP_DIR) \
	&& ./configure \
		--prefix=/usr \
	        --host=$(LFS_TGT)
$(GZIP_DIR):
	$(UNTAR) $(GZIP_TAR)

$(GZIP_TAR):
	$(WGET) $(GZIP_SRC)
