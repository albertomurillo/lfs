COREUTILS_VER := 9.4
COREUTILS_SRC := https://ftp.gnu.org/gnu/coreutils/coreutils-$(COREUTILS_VER).tar.xz
COREUTILS_TAR := $(SOURCES)/$(notdir $(COREUTILS_SRC))
COREUTILS_DIR := $(basename $(basename $(COREUTILS_TAR)))

.PHONY: coreutils
coreutils: $(COREUTILS_TAR) $(COREUTILS_DIR) $(COREUTILS_DIR)/Makefile $(USRSBIN)/chroot

$(USRSBIN)/chroot:
	cd $(COREUTILS_DIR) \
	&& $(MAKE) \
	&& $(MAKE) DESTDIR=$(ROOT) install \
	&& mv -v $(USRBIN)/chroot $(USRSBIN) \
	&& mkdir -pv $(USRSHARE)/man/man8 \
	&& mv -v $(USRSHARE)/man/man1/chroot.1 $(USRSHARE)/man/man8/chroot.8 \
	&& sed -i 's/"1"/"8"/' $(USRSHARE)/man/man8/chroot.8

$(COREUTILS_DIR)/Makefile:
	cd $(COREUTILS_DIR) \
	&& ./configure \
		--prefix=/usr \
		--host=$(LFS_TGT) \
		--build=$(shell $(COREUTILS_DIR)/build-aux/config.guess) \
		--enable-install-program=hostname \
		--enable-no-install-program=kill,uptime

$(COREUTILS_DIR):
	$(UNTAR) $(COREUTILS_TAR)

$(COREUTILS_TAR):
	$(WGET) $(COREUTILS_SRC)
