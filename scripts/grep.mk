GREP_VER := 3.11
GREP_SRC := https://ftp.gnu.org/gnu/grep/grep-$(GREP_VER).tar.xz
GREP_TAR := $(SOURCES)/$(notdir $(GREP_SRC))
GREP_DIR := $(basename $(basename $(GREP_TAR)))

.PHONY: grep
grep: $(GREP_TAR) $(GREP_DIR) $(GREP_DIR)/Makefile $(USRBIN)/grep

$(USRBIN)/grep:
	cd $(GREP_DIR) \
	&& $(MAKE) \
	&& $(MAKE) DESTDIR=$(ROOT) install

$(GREP_DIR)/Makefile:
	cd $(GREP_DIR) \
	&& ./configure \
		--prefix=/usr \
	        --host=$(LFS_TGT) \
	        --build=$(shell $(GREP_DIR)/build-aux/config.guess)

$(GREP_DIR):
	$(UNTAR) $(GREP_TAR)

$(GREP_TAR):
	$(WGET) $(GREP_SRC)
