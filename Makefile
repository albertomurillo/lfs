LFS_TGT := aarch64-lfs-linux-gnu

ROOT := /mnt/lfs
ETC := $(ROOT)/etc
USR := $(ROOT)/usr
USRBIN := $(ROOT)/usr/bin
USRLIB := $(ROOT)/usr/lib
USRLIB64 := $(ROOT)/usr/lib64
USRSBIN := $(ROOT)/usr/sbin
USRSHARE := $(ROOT)/usr/share
VAR := $(ROOT)/var

SOURCES := $(ROOT)/sources
TOOLS := $(ROOT)/tools

MAKE := make -j8
RM := rm -v
UNTAR := tar --directory $(SOURCES) -v -x -f
WGET := wget --continue --directory-prefix=$(SOURCES)

FS_DIRS := $(ETC) $(VAR) $(USRBIN) $(USRLIB) $(USRSBIN) $(TOOLS)
FS_LINKS := $(addprefix $(ROOT)/,bin lib sbin)

.PHONY: all
all: fs cross-toolchain temporary-tools

include scripts/*.mk

.PHONY: fs
fs: $(FS_DIRS) $(FS_LINKS) $(SOURCES)

$(FS_DIRS):
	mkdir -p $@

$(FS_LINKS):
	ln -sv $(patsubst $(ROOT)/%,$(USR)/%,$@) $@

$(SOURCES):
	mkdir -p $(SOURCES)
	chmod -v a+wt $(SOURCES)

.PHONY: cross-toolchain
cross-toolchain: \
	binutils-pass1 \
	gcc-pass1 \
	linux-api-headers \
	glibc \
	libstdc++

.PHONY: temporary-tools
temporary-tools: \
	m4 \
	ncurses \
	bash \
	coreutils \
	diffutils \
	file \
	findutils \
	gawk \
	grep \
	gzip \
	make \
	patch \
	sed \
	tar \
	binutils-pass2 \
	gcc-pass2
