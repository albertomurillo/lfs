GCC_VER := 13.2.0
GCC_SRC := https://ftp.gnu.org/gnu/gcc/gcc-$(GCC_VER)/gcc-$(GCC_VER).tar.xz
GCC_TAR := $(SOURCES)/$(notdir $(GCC_SRC))
GCC_DIR := $(basename $(basename $(GCC_TAR)))

MPFR_VER := 4.2.1
MPFR_SRC := https://ftp.gnu.org/gnu/mpfr/mpfr-$(MPFR_VER).tar.xz
MPFR_TAR := $(SOURCES)/$(notdir $(MPFR_SRC))
MPFR_DIR := $(basename $(basename $(MPFR_TAR)))

GMP_VER := 6.3.0
GMP_SRC := https://ftp.gnu.org/gnu/gmp/gmp-$(GMP_VER).tar.xz
GMP_TAR := $(SOURCES)/$(notdir $(GMP_SRC))
GMP_DIR := $(basename $(basename $(GMP_TAR)))

MPC_VER := 1.3.1
MPC_SRC := https://ftp.gnu.org/gnu/mpc/mpc-$(MPC_VER).tar.gz
MPC_TAR := $(SOURCES)/$(notdir $(MPC_SRC))
MPC_DIR := $(basename $(basename $(MPC_TAR)))

.PHONY: gcc
gcc: $(GCC_TAR) $(MPFR_TAR) $(GMP_TAR) $(MPC_TAR) $(GCC_DIR)

$(GCC_DIR):
	$(UNTAR) $(GCC_TAR)
	$(UNTAR) $(MPFR_TAR)
	$(UNTAR) $(GMP_TAR)
	$(UNTAR) $(MPC_TAR)
	mv $(MPFR_DIR) $(GCC_DIR)/mpfr
	mv $(GMP_DIR) $(GCC_DIR)/gmp
	mv $(MPC_DIR) $(GCC_DIR)/mpc

$(GCC_TAR):
	$(WGET) $(GCC_SRC)

$(MPFR_TAR):
	$(WGET) $(MPFR_SRC)

$(GMP_TAR):
	$(WGET) $(GMP_SRC)

$(MPC_TAR):
	$(WGET) $(MPC_SRC)

.PHONY: gcc-pass1
gcc-pass1: gcc $(GCC_DIR)/pass1/Makefile $(TOOLS)/bin/$(LFS_TGT)-gcc

$(TOOLS)/bin/$(LFS_TGT)-gcc:
	cd $(GCC_DIR)/pass1 \
	&& $(MAKE) \
	&& $(MAKE) install \
	&& cd .. \
	&& cat gcc/limitx.h gcc/glimits.h gcc/limity.h > $(dir $(shell $(LFS_TGT)-g++ -print-libgcc-file-name))/include/limits.h

$(GCC_DIR)/pass1/Makefile:
	mkdir -p $(GCC_DIR)/pass1
	cd $(GCC_DIR)/pass1 \
	&& ../configure \
		--target=$(LFS_TGT) \
		--prefix=$(TOOLS) \
		--with-glibc-version=$(GLIBC_VER) \
		--with-sysroot=$(ROOT) \
		--with-newlib \
		--without-headers \
		--enable-default-pie \
		--enable-default-ssp \
		--disable-nls \
		--disable-shared \
		--disable-multilib \
		--disable-threads \
		--disable-libatomic \
		--disable-libgomp \
		--disable-libquadmath \
		--disable-libssp \
		--disable-libvtv \
		--disable-libstdcxx \
		--enable-languages=c,c++

.PHONY: gcc-pass2
gcc-pass2: gcc $(GCC_DIR)/pass2/Makefile $(USRBIN)/gcc

$(USRBIN)/gcc:
	cd $(GCC_DIR)/pass2 \
	&& $(MAKE) \
	&& $(MAKE) DESTDIR=$(ROOT) install
	ln -sv gcc $(USRBIN)/cc

$(GCC_DIR)/pass2/Makefile:
	sed -i '/thread_header =/s/@.*@/gthr-posix.h/' \
		$(GCC_DIR)/libgcc/Makefile.in \
		$(GCC_DIR)/libstdc++-v3/include/Makefile.in

	mkdir -p $(GCC_DIR)/pass2/
	cd $(GCC_DIR)/pass2/ \
	&& ../configure \
		--build=$(shell $(GCC_DIR)/config.guess) \
		--host=$(LFS_TGT) \
		--target=$(LFS_TGT) \
		LDFLAGS_FOR_TARGET=-L$(GCC_DIR)/pass2/$(LFS_TGT)/libgcc \
		--prefix=/usr \
		--with-build-sysroot=$(ROOT) \
		--enable-default-pie \
		--enable-default-ssp \
		--disable-nls \
		--disable-multilib \
		--disable-libatomic \
		--disable-libgomp \
		--disable-libquadmath \
		--disable-libsanitizer \
		--disable-libssp \
		--disable-libvtv \
		--enable-languages=c,c++

.PHONY: libstdc++
libstdc++: $(GCC_DIR)/build_libstdc/Makefile $(USRLIB64)/libstdc++.so

$(USRLIB64)/libstdc++.so:
	cd $(GCC_DIR)/build_libstdc/ \
	&& $(MAKE) \
	&& $(MAKE) DESTDIR=$(ROOT) install \
	&& $(RM) $(addsuffix .la,$(addprefix $(USRLIB64)/lib,stdc++ stdc++fs stdc++exp supc++))

$(GCC_DIR)/build_libstdc/Makefile:
	mkdir -p $(GCC_DIR)/build_libstdc/
	cd $(GCC_DIR)/build_libstdc/ \
	&& ../libstdc++-v3/configure \
		--host=$(LFS_TGT) \
		--build=$(shell $(GCC_DIR)/config.guess) \
		--prefix=/usr \
		--disable-multilib \
		--disable-nls \
		--disable-libstdcxx-pch \
		--with-gxx-include-dir=/tools/$(LFS_TGT)/include/c++/$(GCC_VER)
