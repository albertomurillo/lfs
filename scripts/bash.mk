BASH_VER := 5.2.15
BASH_SRC := https://ftp.gnu.org/gnu/bash/bash-$(BASH_VER).tar.gz
BASH_TAR := $(SOURCES)/$(notdir $(BASH_SRC))
BASH_DIR := $(basename $(basename $(BASH_TAR)))

.PHONY: bash
bash: $(BASH_TAR) $(BASH_DIR) $(BASH_DIR)/Makefile $(USRBIN)/bash

$(USRBIN)/bash:
	cd $(BASH_DIR) \
	&& $(MAKE) \
	&& $(MAKE) DESTDIR=$(ROOT) install \
	&& ln -sv bash $(USRBIN)/sh

$(BASH_DIR)/Makefile:
	cd $(BASH_DIR) \
	&& ./configure \
		--prefix=/usr \
		--build=$(shell $(BASH_DIR)/support/config.guess) \
		--host=$(LFS_TGT) \
		--without-bash-malloc

$(BASH_DIR):
	$(UNTAR) $(BASH_TAR)

$(BASH_TAR):
	$(WGET) $(BASH_SRC)
