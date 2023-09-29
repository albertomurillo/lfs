LINUX_VER := 6.5.3
LINUX_SRC := https://www.kernel.org/pub/linux/kernel/v6.x/linux-$(LINUX_VER).tar.xz
LINUX_TAR := $(SOURCES)/$(notdir $(LINUX_SRC))
LINUX_DIR := $(basename $(basename $(LINUX_TAR)))

.PHONY: linux-api-headers
linux-api-headers: $(LINUX_TAR) $(LINUX_DIR) $(USR)/include/linux

$(USR)/include/linux:
	cd $(LINUX_DIR) \
	&& $(MAKE) mrproper \
	&& $(MAKE) headers \
	&& mkdir -p $(USR)/include \
	&& rsync -mrl --include='*/' --include='*\.h' --exclude='*' usr/include $(USR)

$(LINUX_DIR):
	$(UNTAR) $(LINUX_TAR)

$(LINUX_TAR):
	$(WGET) $(LINUX_SRC)
