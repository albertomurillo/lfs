SED_VER := 4.9
SED_SRC := https://ftp.gnu.org/gnu/sed/sed-$(SED_VER).tar.xz
SED_TAR := $(SOURCES)/$(notdir $(SED_SRC))
SED_DIR := $(basename $(basename $(SED_TAR)))

.PHONY: sed
sed: $(SED_TAR) $(SED_DIR) $(SED_DIR)/Makefile $(USRBIN)/sed

$(USRBIN)/sed:
	cd $(SED_DIR) \
	&& $(MAKE) \
	&& $(MAKE) DESTDIR=$(ROOT) install

$(SED_DIR)/Makefile:
	cd $(SED_DIR) \
	&& ./configure \
		--prefix=/usr \
		--host=$(LFS_TGT) \
		--build=$(shell $(SED_DIR)/build-aux/config.guess)
$(SED_DIR):
	$(UNTAR) $(SED_TAR)

$(SED_TAR):
	$(WGET) $(SED_SRC)
