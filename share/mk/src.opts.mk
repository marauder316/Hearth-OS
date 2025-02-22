# $FreeBSD: stable/11/share/mk/src.opts.mk 360290 2020-04-25 05:51:58Z delphij $
#
# Option file for MidnightBSD /usr/src builds.
#
# Users define WITH_FOO and WITHOUT_FOO on the command line or in /etc/src.conf
# and /etc/make.conf files. These translate in the build system to MK_FOO={yes,no}
# with sensible (usually) defaults.
#
# Makefiles must include bsd.opts.mk after defining specific MK_FOO options that
# are applicable for that Makefile (typically there are none, but sometimes there
# are exceptions). Recursive makes usually add MK_FOO=no for options that they wish
# to omit from that make.
#
# Makefiles must include bsd.mkopt.mk before they test the value of any MK_FOO
# variable.
#
# Makefiles may also assume that this file is included by src.opts.mk should it
# need variables defined there prior to the end of the Makefile where
# bsd.{subdir,lib.bin}.mk is traditionally included.
#
# The old-style YES_FOO and NO_FOO are being phased out. No new instances of them
# should be added. Old instances should be removed.
#
# Makefiles should never test WITH_FOO or WITHOUT_FOO directly (although an
# exception is made for _WITHOUT_SRCONF which turns off this mechanism
# completely inside bsd.*.mk files).
#

.if !target(__<src.opts.mk>__)
__<src.opts.mk>__:

.include <bsd.own.mk>

#
# Define MK_* variables (which are either "yes" or "no") for users
# to set via WITH_*/WITHOUT_* in /etc/src.conf and override in the
# make(1) environment.
# These should be tested with `== "no"' or `!= "no"' in makefiles.
# The NO_* variables should only be set by makefiles for variables
# that haven't been converted over.
#

# These options are used by src the builds

__DEFAULT_YES_OPTIONS = \
    ACCT \
    ACPI \
    AMD \
    APM \
    ASH \
    AT \
    ATM \
    AUDIT \
    AUTHPF \
    AUTOFS \
    BHYVE \
    BINUTILS \
    BINUTILS_BOOTSTRAP \
    BLACKLIST \
    BLUETOOTH \
    BOOT \
    BOOTPARAMD \
    BOOTPD \
    BSD_CPIO \
    BSD_GREP_FASTMATCH \
    BSDINSTALL \
    BSNMP \
    BZIP2 \
    CALENDAR \
    CAPSICUM \
    CAROOT \
    CASPER \
    CCD \
    CDDL \
    CPP \
    CROSS_COMPILER \
    CRYPT \
    CTM \
    CUSE \
    CXX \
    DIALOG \
    DICT \
    DMAGENT \
    DYNAMICROOT \
    ED_CRYPTO \
    EE \
    ELFCOPY_AS_OBJCOPY \
    EFI \
    ELFTOOLCHAIN_BOOTSTRAP \
    EXAMPLES \
    FDT \
    FILE \
    FINGER \
    FLOPPY \
    FMTREE \
    FORTH \
    FP_LIBC \
    FTP \
    GAMES \
    GCOV \
    GDB \
    GNU \
    GNU_DIFF \
    GNU_GREP \
    GNU_GREP_COMPAT \
    GPIO \
    GPL_DTC \
    GROFF \
    HAST \
    HTML \
    HYPERV \
    ICONV \
    INET \
    INET6 \
    INETD \
    IPFILTER \
    IPFW \
    ISCSI \
    JAIL \
    KDUMP \
    KVM \
    LDNS \
    LDNS_UTILS \
    LEGACY_CONSOLE \
    LIB32 \
    LIBPTHREAD \
    LIBTHR \
    LLVM_COV \
    LOADER_GELI \
    LOADER_LUA \
    LOADER_OFW \
    LOADER_UBOOT \
    LOCALES \
    LOCATE \
    LPR \
    LS_COLORS \
    LZMA_SUPPORT \
    MAIL \
    MAILWRAPPER \
    MAKE \
    MIDNIGHTBSD_UPDATE \
    NDIS \
    NETCAT \
    NETGRAPH \
    NLS_CATALOGS \
    NS_CACHING \
    NTP \
    OPENSSL \
    PAM \
    PC_SYSINSTALL \
    PF \
    PKGBOOTSTRAP \
    PMC \
    PORTSNAP \
    PPP \
    QUOTAS \
    RADIUS_SUPPORT \
    RCMDS \
    RBOOTD \
    RCS \
    RESCUE \
    ROUTED \
    SENDMAIL \
    SETUID_LOGIN \
    SHAREDOCS \
    SOURCELESS \
    SOURCELESS_HOST \
    SOURCELESS_UCODE \
    SVNLITE \
    SYSCONS \
    SYSTEM_COMPILER \
    TALK \
    TCP_WRAPPERS \
    TCSH \
    TELNET \
    TEXTPROC \
    TFTP \
    TIMED \
    UNBOUND \
    USB \
    UTMPX \
    VI \
    VT \
    WIRELESS \
    WPA_SUPPLICANT_EAPOL \
    ZFS \
    LOADER_ZFS \
    ZONEINFO

__DEFAULT_NO_OPTIONS = \
    BSD_GREP \
    CLANG_EXTRAS \
    DTRACE_TESTS \
    EISA \
    HESIOD \
    LIBSOFT \
    LINT \
    LLVM_ASSERTIONS \
    LOADER_FIREWIRE \
    LOADER_FORCE_LE \
    LOADER_VERBOSE \
    MANDOCDB \
    NAND \
    OFED_EXTRA \
    OPENLDAP \
    REPRODUCIBLE_BUILD \
    RPCBIND_WARMSTART_SUPPORT \
    SHARED_TOOLCHAIN \
    SORT_THREADS \
    SVN \
    TESTS \
    ZONEINFO_LEAPSECONDS_SUPPORT \
    ZONEINFO_OLD_TIMEZONES_SUPPORT


#
# Default behaviour of some options depends on the architecture.  Unfortunately
# this means that we have to test TARGET_ARCH (the buildworld case) as well
# as MACHINE_ARCH (the non-buildworld case).  Normally TARGET_ARCH is not
# used at all in bsd.*.mk, but we have to make an exception here if we want
# to allow defaults for some things like clang to vary by target architecture.
# Additional, per-target behavior should be rarely added only after much
# gnashing of teeth and grinding of gears.
#
.if defined(TARGET_ARCH)
__T=${TARGET_ARCH}
.else
__T=${MACHINE_ARCH}
.endif
.if defined(TARGET)
__TT=${TARGET}
.else
__TT=${MACHINE}
.endif

__DEFAULT_NO_OPTIONS+=LLVM_TARGET_BPF
__DEFAULT_NO_OPTIONS+=LLVM_TARGET_RISCV

.include <bsd.compiler.mk>
# If the compiler is not C++11 capable, disable Clang and use GCC instead.
# This means that architectures that have GCC 4.2 as default can not
# build Clang without using an external compiler.

.if ${COMPILER_FEATURES:Mc++11} && (${__T} == "aarch64" || \
    ${__T} == "amd64" || ${__TT} == "arm" || ${__T} == "i386")
# Clang is enabled, and will be installed as the default /usr/bin/cc.
__DEFAULT_YES_OPTIONS+=CLANG CLANG_BOOTSTRAP CLANG_FULL CLANG_IS_CC LLD
__DEFAULT_YES_OPTIONS+=LLVM_TARGET_AARCH64 LLVM_TARGET_ARM LLVM_TARGET_MIPS
__DEFAULT_YES_OPTIONS+=LLVM_TARGET_POWERPC LLVM_TARGET_SPARC LLVM_TARGET_X86
__DEFAULT_NO_OPTIONS+=GCC GCC_BOOTSTRAP GNUCXX
.elif ${COMPILER_FEATURES:Mc++11} && ${__T} != "riscv64" && ${__T} != "sparc64"
# If an external compiler that supports C++11 is used as ${CC} and Clang
# supports the target, then Clang is enabled but GCC is installed as the
# default /usr/bin/cc.
__DEFAULT_YES_OPTIONS+=CLANG CLANG_FULL GCC GCC_BOOTSTRAP GNUCXX
__DEFAULT_YES_OPTIONS+=LLVM_TARGET_AARCH64 LLVM_TARGET_ARM LLVM_TARGET_MIPS
__DEFAULT_YES_OPTIONS+=LLVM_TARGET_POWERPC LLVM_TARGET_SPARC LLVM_TARGET_X86
__DEFAULT_NO_OPTIONS+=CLANG_BOOTSTRAP CLANG_IS_CC LLD
.else
# Everything else disables Clang, and uses GCC instead.
__DEFAULT_YES_OPTIONS+=GCC GCC_BOOTSTRAP GNUCXX
__DEFAULT_NO_OPTIONS+=CLANG CLANG_BOOTSTRAP CLANG_FULL CLANG_IS_CC LLD
__DEFAULT_NO_OPTIONS+=LLVM_TARGET_AARCH64 LLVM_TARGET_ARM LLVM_TARGET_MIPS
__DEFAULT_NO_OPTIONS+=LLVM_TARGET_POWERPC LLVM_TARGET_SPARC LLVM_TARGET_X86
.endif
__DEFAULT_NO_OPTIONS+=LLVM_TARGET_BPF
# In-tree binutils/gcc are older versions without modern architecture support.
.if ${__T} == "aarch64" || ${__T} == "riscv64"
BROKEN_OPTIONS+=BINUTILS BINUTILS_BOOTSTRAP GCC GCC_BOOTSTRAP GDB
.endif
.if ${__T} == "aarch64" || ${__T} == "amd64" || ${__T} == "i386" || \
    ${__T:Mriscv*} != "" || ${__TT} == "mips"
__DEFAULT_YES_OPTIONS+=LLVM_LIBUNWIND
.else
__DEFAULT_NO_OPTIONS+=LLVM_LIBUNWIND
.endif
.if ${__T} == "riscv64"
BROKEN_OPTIONS+=PROFILE # "sorry, unimplemented: profiler support for RISC-V"
BROKEN_OPTIONS+=TESTS   # "undefined reference to `_Unwind_Resume'"
BROKEN_OPTIONS+=CXX     # "libcxxrt.so: undefined reference to `_Unwind_Resume_or_Rethrow'"
.endif
.if ${__T} == "aarch64"
__DEFAULT_YES_OPTIONS+=LLD_BOOTSTRAP LLD_IS_LD
.else
__DEFAULT_NO_OPTIONS+=LLD_BOOTSTRAP LLD_IS_LD
.endif
.if ${__T} == "aarch64" || ${__T} == "amd64"
__DEFAULT_YES_OPTIONS+=LLDB
.else
__DEFAULT_NO_OPTIONS+=LLDB
.endif
# LLVM lacks support for MidnightBSD 64-bit atomic operations for ARMv4/ARMv5
.if ${__T} == "arm" || ${__T} == "armeb"
BROKEN_OPTIONS+=LLDB
.endif
# Only doing soft float API stuff on armv6
.if ${__T} != "armv6"
BROKEN_OPTIONS+=LIBSOFT
.endif
# EFI doesn't exist on mips, pc98, powerpc, sparc or riscv.
.if ${__T:Mmips*} || ${__TT:Mpc98*} || ${__T:Mpowerpc*} || ${__T:Msparc64} || \
    ${__T:Mriscv*}
BROKEN_OPTIONS+=EFI
.endif
# OFW is only for powerpc and sparc64, exclude others
.if ${__T:Mpowerpc*} == "" && ${__T:Msparc64} == ""
BROKEN_OPTIONS+=LOADER_OFW
.endif
# UBOOT is only for arm, mips and powerpc, exclude others
.if ${__T:Marm*} == "" && ${__T:Mmips*} == "" && ${__T:Mpowerpc*} == ""
BROKEN_OPTIONS+=LOADER_UBOOT
.endif
# GELI and Lua in loader currently cause boot failures on sparc64 and powerpc.
# Further debugging is required -- probably they are just broken on big
# endian systems generically (they jump to null pointers or try to read
# crazy high addresses, which is typical of endianness problems).
.if ${__T} == "sparc64" || ${__T:Mpowerpc*}
BROKEN_OPTIONS+=LOADER_GELI LOADER_LUA
.endif
# Both features are untested on pc98, so we'll mark them as disabled just to
# be safe and make sure we keep pc98 stable.
.if ${__TT:Mpc98*}
BROKEN_OPTIONS+=LOADER_GELI LOADER_LUA
.endif
.if ${__T:Mmips64*}
# profiling won't work on MIPS64 because there is only assembly for o32
BROKEN_OPTIONS+=PROFILE
.endif
.if ${__T} == "aarch64" || ${__T} == "amd64" || ${__T} == "i386" || \
    ${__T} == "powerpc64" || ${__T} == "sparc64"
__DEFAULT_YES_OPTIONS+=CXGBETOOL
__DEFAULT_YES_OPTIONS+=MLX5TOOL
.else
__DEFAULT_NO_OPTIONS+=CXGBETOOL
__DEFAULT_NO_OPTIONS+=MLX5TOOL
.endif

.if ${__T} == "amd64"
__DEFAULT_YES_OPTIONS+=OFED
.else
__DEFAULT_NO_OPTIONS+=OFED
.endif

.if ${COMPILER_FEATURES:Mc++11} && (${__T} == "amd64" || ${__T} == "i386")
__DEFAULT_YES_OPTIONS+=OPENMP
.else
__DEFAULT_NO_OPTIONS+=OPENMP
.endif

.include <bsd.mkopt.mk>

#
# MK_* options that default to "yes" if the compiler is a C++11 compiler.
#
.for var in \
    LIBCPLUSPLUS
.if !defined(MK_${var})
.if ${COMPILER_FEATURES:Mc++11}
.if defined(WITHOUT_${var})
MK_${var}:=	no
.else
MK_${var}:=	yes
.endif
.else
.if defined(WITH_${var})
MK_${var}:=	yes
.else
MK_${var}:=	no
.endif
.endif
.endif
.endfor

#
# Force some options off if their dependencies are off.
# Order is somewhat important.
#
.if !${COMPILER_FEATURES:Mc++11}
MK_LLVM_LIBUNWIND:=	no
.endif

.if ${MK_CAPSICUM} == "no"
MK_CASPER:=	no
.endif

.if ${MK_LIBPTHREAD} == "no"
MK_LIBTHR:=	no
.endif

.if ${MK_LDNS} == "no"
MK_LDNS_UTILS:=	no
MK_UNBOUND:= no
.endif

.if ${MK_SOURCELESS} == "no"
MK_SOURCELESS_HOST:=	no
MK_SOURCELESS_UCODE:= no
.endif

.if ${MK_CDDL} == "no"
MK_ZFS:=	no
MK_LOADER_ZFS:=	no
MK_CTF:=	no
.endif

.if ${MK_CRYPT} == "no"
MK_OPENSSL:=	no
MK_OPENSSH:=	no
MK_KERBEROS:=	no
.endif

.if ${MK_CXX} == "no"
MK_CLANG:=	no
MK_GROFF:=	no
MK_GNUCXX:=	no
.endif

.if ${MK_DIALOG} == "no"
MK_BSDINSTALL:=	no
.endif

.if ${MK_MAIL} == "no"
MK_MAILWRAPPER:= no
MK_SENDMAIL:=	no
MK_DMAGENT:=	no
.endif

.if ${MK_NETGRAPH} == "no"
MK_ATM:=	no
MK_BLUETOOTH:=	no
.endif

.if ${MK_NLS} == "no"
MK_NLS_CATALOGS:= no
.endif

.if ${MK_OPENSSL} == "no"
MK_OPENSSH:=	no
MK_KERBEROS:=	no
.endif

.if ${MK_OFED} == "no"
MK_OFED_EXTRA:=	no
.endif

.if ${MK_PF} == "no"
MK_AUTHPF:=	no
.endif

.if ${MK_TESTS} == "no"
MK_DTRACE_TESTS:= no
.endif

.if ${MK_TEXTPROC} == "no"
MK_GROFF:=	no
.endif

.if ${MK_ZONEINFO} == "no"
MK_ZONEINFO_LEAPSECONDS_SUPPORT:= no
MK_ZONEINFO_OLD_TIMEZONES_SUPPORT:= no
.endif

.if ${MK_CROSS_COMPILER} == "no"
MK_BINUTILS_BOOTSTRAP:= no
MK_CLANG_BOOTSTRAP:= no
MK_ELFTOOLCHAIN_BOOTSTRAP:= no
MK_GCC_BOOTSTRAP:= no
MK_LLD_BOOTSTRAP:= no
.endif

.if ${MK_META_MODE} == "yes"
MK_SYSTEM_COMPILER:= no
.endif

.if ${MK_TOOLCHAIN} == "no"
MK_BINUTILS:=	no
MK_CLANG:=	no
MK_GCC:=	no
MK_GDB:=	no
MK_INCLUDES:=	no
MK_LLD:=	no
MK_LLDB:=	no
.endif

.if ${MK_CLANG} == "no"
MK_CLANG_EXTRAS:= no
MK_CLANG_FULL:= no
MK_LLVM_COV:= no
.endif

#
# MK_* options whose default value depends on another option.
#
.for vv in \
    GSSAPI/KERBEROS \
    MAN_UTILS/MAN
.if defined(WITH_${vv:H})
MK_${vv:H}:=	yes
.elif defined(WITHOUT_${vv:H})
MK_${vv:H}:=	no
.else
MK_${vv:H}:=	${MK_${vv:T}}
.endif
.endfor

#
# Set defaults for the MK_*_SUPPORT variables.
#

#
# MK_*_SUPPORT options which default to "yes" unless their corresponding
# MK_* variable is set to "no".
#
.for var in \
    BLACKLIST \
    BZIP2 \
    GNU \
    INET \
    INET6 \
    KERBEROS \
    KVM \
    NETGRAPH \
    PAM \
    TESTS \
    WIRELESS
.if defined(WITHOUT_${var}_SUPPORT) || ${MK_${var}} == "no"
MK_${var}_SUPPORT:= no
.else
MK_${var}_SUPPORT:= yes
.endif
.endfor

.if !${COMPILER_FEATURES:Mc++11}
MK_LLDB:=	no
.endif

# gcc 4.8 and newer supports libc++, so suppress gnuc++ in that case.
# while in theory we could build it with that, we don't want to do
# that since it creates too much confusion for too little gain.
# XXX: This is incomplete and needs X_COMPILER_TYPE/VERSION checks too
#      to prevent Makefile.inc1 from bootstrapping unneeded dependencies
#      and to support 'make delete-old' when supplying an external toolchain.
.if ${COMPILER_TYPE} == "gcc" && ${COMPILER_VERSION} >= 40800
MK_GNUCXX:=no
MK_GCC:=no
.endif

.endif #  !target(__<src.opts.mk>__)
