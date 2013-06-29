TOOLCHAIN_BUILD_INTERMEDIATES := $(TOOLCHAIN_INTERMEDIATES)build
TOOLCHAINS_SOURCE_STMP := $(TOOLCHAIN_INTERMEDIATES)stmp-source
TOOLCHAINS_CONFIG_STMP := $(TOOLCHAIN_INTERMEDIATES)stmp-config
TOOLCHAINS_BUILD_STMP := $(TOOLCHAIN_INTERMEDIATES)stmp-build
TOOLCHAINS_INSTALL_STMP := $(TOOLCHAIN_INTERMEDIATES)stmp-install

TOOLCHAINS_SOURCE := binutils cloog gcc gdb gmp mpc mpfr ppl isl expat

TOOLCHAIN_SOURCE_INTERMEDIATES := $(addprefix $(TOOLCHAIN_INTERMEDIATES), \
                                              $(TOOLCHAINS_SOURCE))

TOOLCHAIN_GCC_VERSION := 4.8
TOOLCHAIN_GDB_VERSION := 7.6
TOOLCHAIN_BINTUILS_VERSION := 2.23
TOOLCHAIN_MPFR_VERSION := 3.1.1
TOOLCHAIN_GMP_VERSION := 5.0.5
TOOLCHAIN_CLOOG_VERSION := 0.18.0
TOOLCHAIN_MPC_VERSION := 1.0.1
TOOLCHAIN_PPL_VERSION := 1.0
TOOLCHAIN_ISL_VERSION := 0.11.1
TOOLCHAIN_EXPAT_VERSION := 2.0.1
TOOLCHAIN_PREFIX := $(realpath $(TOOLCHAIN_ROOT))
TOOLCHAIN_SYSROOT := $(realpath $(TARGET_SYSROOT))

TOOLCHAIN_CONFIG_ARGS := \
  --target=arm-linux-androideabi \
  --prefix=$(TOOLCHAIN_PREFIX) \
  --with-sysroot=$(TOOLCHAIN_SYSROOT) \
  --program-transform-name="s&^&arm-olibc-linux-gnueabi-&" \
  --with-gcc-version=$(TOOLCHAIN_GCC_VERSION) \
  --with-gdb-version=$(TOOLCHAIN_GDB_VERSION) \
  --with-binutils-version=$(TOOLCHAIN_BINTUILS_VERSION) \
  --with-mpfr-version=$(TOOLCHAIN_MPFR_VERSION) \
  --with-gmp-version=$(TOOLCHAIN_GMP_VERSION) \
  --with-mpc-version=$(TOOLCHAIN_MPC_VERSION) \
  --with-ppl-version=$(TOOLCHAIN_PPL_VERSION) \
  --with-isl-version=$(TOOLCHAIN_ISL_VERSION) \
  --with-cloog-version=$(TOOLCHAIN_CLOOG_VERSION) \
  --with-expat-version=$(TOOLCHAIN_EXPAT_VERSION) \

STANDALONGE_TOOLCAHIN_GOAL := $(TOOLCHAINS_INSTALL_STMP)

$(TOOLCHAIN_BUILD_INTERMEDIATES)/stmp-install-gcc: \
    $(TOOLCHAIN_BUILD_INTERMEDIATES)/stmp-build-target-gcc
	$(MAKE) -C $(TOOLCHAIN_BUILD_INTERMEDIATES) install && touch $@

$(TOOLCHAINS_INSTALL_STMP): $(TOOLCHAINS_BUILD_STMP)
	$(MAKE) -C $(TOOLCHAIN_BUILD_INTERMEDIATES) install && touch $@

$(TOOLCHAINS_BUILD_STMP): $(TOOLCHAINS_CONFIG_STMP)
	cd $(TOOLCHAIN_BUILD_INTERMEDIATES) && $(MAKE) build
	touch $(TOOLCHAIN_BUILD_INTERMEDIATES)/Makefile

$(TOOLCHAINS_CONFIG_STMP): $(TOOLCHAINS_SOURCE_STMP) \
                           sysroot \
                           $(OLIBC_CONF)
	cd $(TOOLCHAIN_BUILD_INTERMEDIATES) && \
	./configure $(TOOLCHAIN_CONFIG_ARGS)
	touch $@

$(TOOLCHAINS_SOURCE_STMP):
	#git clone https://android.googlesource.com/toolchain/gcc $(TOOLCHAIN_INTERMEDIATES)/gcc
	#git clone https://android.googlesource.com/toolchain/gdb $(TOOLCHAIN_INTERMEDIATES)/gdb
	#git clone https://android.googlesource.com/toolchain/binutils $(TOOLCHAIN_INTERMEDIATES)/binutils
	#git clone https://android.googlesource.com/toolchain/mpc $(TOOLCHAIN_INTERMEDIATES)/mpc
	#git clone https://android.googlesource.com/toolchain/gmp $(TOOLCHAIN_INTERMEDIATES)/gmp
	#git clone https://android.googlesource.com/toolchain/expat $(TOOLCHAIN_INTERMEDIATES)/expat
	#git clone https://android.googlesource.com/toolchain/mpfr $(TOOLCHAIN_INTERMEDIATES)/mpfr
	#git clone https://android.googlesource.com/toolchain/isl $(TOOLCHAIN_INTERMEDIATES)/isl
	#git clone https://android.googlesource.com/toolchain/ppl $(TOOLCHAIN_INTERMEDIATES)/ppl
	#git clone https://android.googlesource.com/toolchain/cloog $(TOOLCHAIN_INTERMEDIATES)/cloog
	git clone git@github.com:olibc/toolchain-build.git $(TOOLCHAIN_INTERMEDIATES)/build
	touch $@

$(TOOLCHAIN_INTERMEDIATES)%:
	git clone https://android.googlesource.com/toolchain/$(notdir $@) $@

$(TOOLCHAIN_BUILD_INTERMEDIATES):
	git clone git@github.com:olibc/toolchain-build.git $@

standalone-toolchain: $(STANDALONGE_TOOLCAHIN_GOAL)
