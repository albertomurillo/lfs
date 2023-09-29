GLIBC_VER := 2.38
GLIBC_SRC := https://ftp.gnu.org/gnu/glibc/glibc-$(GLIBC_VER).tar.xz
GLIBC_TAR := $(SOURCES)/$(notdir $(GLIBC_SRC))
GLIBC_DIR := $(basename $(basename $(GLIBC_TAR)))

GLIBC_PATCH1 := https://www.linuxfromscratch.org/patches/lfs/development/glibc-2.38-fhs-1.patch
# GLIBC_PATCH1 := https://www.linuxfromscratch.org/patches/lfs/12.0/glibc-2.38-fhs-1.patch

.PHONY: glibc
glibc: $(GLIBC_TAR) $(GLIBC_DIR) $(GLIBC_DIR)/build/Makefile $(USRBIN)/ldd

$(USRBIN)/ldd:
	cd $(GLIBC_DIR)/build \
	&& $(MAKE) \
	&& $(MAKE) DESTDIR=$(ROOT) install
	sed '/RTLDLIST=/s@/usr@@g' -i $(USRBIN)/ldd

$(GLIBC_DIR)/build/Makefile:
	mkdir -p $(GLIBC_DIR)/build
	cd $(GLIBC_DIR)/build \
	&& echo "rootsbindir=/usr/sbin" > configparms \
	&& ../configure \
		--prefix=/usr \
		--host=$(LFS_TGT) \
		--build=$(shell $(GLIBC_DIR)/scripts/config.guess) \
		--enable-kernel=$(LINUX_VER) \
		--with-headers=$(USR)/include \
		--disable-mathvec \
		libc_cv_slibdir=/usr/lib

$(GLIBC_DIR): $(SOURCES)/$(notdir $(GLIBC_PATCH1))
	$(UNTAR) $(GLIBC_TAR)
	cd $(GLIBC_DIR) \
	&& patch -Np1 -i ../$(notdir $(GLIBC_PATCH1))

$(SOURCES)/$(notdir $(GLIBC_PATCH1)):
	$(WGET) $(GLIBC_PATCH1)

$(GLIBC_TAR):
	$(WGET) $(GLIBC_SRC)
