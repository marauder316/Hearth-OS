# $FreeBSD: stable/11/lib/libclang_rt/tsan_cxx/Makefile 344213 2019-02-16 15:57:29Z dim $

.include <bsd.init.mk>

LIB=		clang_rt.tsan_cxx-${CRTARCH}

SRCS+=		tsan/rtl/tsan_new_delete.cc
SRCS+=		ubsan/ubsan_handlers_cxx.cc
SRCS+=		ubsan/ubsan_type_hash.cc
SRCS+=		ubsan/ubsan_type_hash_itanium.cc

.include <bsd.lib.mk>

CXXFLAGS.ubsan_handlers_cxx.cc=		-frtti
CXXFLAGS.ubsan_type_hash.cc=		-frtti
CXXFLAGS.ubsan_type_hash_itanium.cc=	-frtti
