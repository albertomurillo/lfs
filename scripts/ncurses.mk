NCURSES_VER := 6.4
NCURSES_SRC := https://invisible-mirror.net/archives/ncurses/ncurses-$(NCURSES_VER).tar.gz
NCURSES_TAR := $(SOURCES)/$(notdir $(NCURSES_SRC))
NCURSES_DIR := $(basename $(basename $(NCURSES_TAR)))

.PHONY: ncurses
ncurses: $(NCURSES_TAR) $(NCURSES_DIR) $(NCURSES_DIR)/Makefile $(USRLIB)/libncurses.so

$(USRLIB)/libncurses.so:
	cd $(NCURSES_DIR) \
	&& $(MAKE) \
	&& $(MAKE) DESTDIR=$(ROOT) TIC_PATH=$(NCURSES_DIR)/build/progs/tic install
	echo "INPUT(-lncursesw)" > $(USRLIB)/libncurses.so

$(NCURSES_DIR)/Makefile:
	sed -i s/mawk// $(NCURSES_DIR)/configure

	mkdir -p $(NCURSES_DIR)/build
	cd $(NCURSES_DIR)/build \
	&& ../configure \
	&& make -C include \
	&& make -C progs tic

	cd $(NCURSES_DIR) \
	&& ./configure \
		--prefix=/usr \
		--host=$(LFS_TGT) \
		--build=$(shell $(NCURSES_DIR)/config.guess) \
		--mandir=/usr/share/man \
		--with-manpage-format=normal \
		--with-shared \
		--without-normal \
		--with-cxx-shared \
		--without-debug \
		--without-ada \
		--disable-stripping \
		--enable-widec

$(NCURSES_DIR):
	$(UNTAR) $(NCURSES_TAR)

$(NCURSES_TAR):
	$(WGET) $(NCURSES_SRC)
