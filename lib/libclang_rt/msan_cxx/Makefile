# $FreeBSD: stable/11/lib/libclang_rt/msan_cxx/Makefile 337260 2018-08-03 15:30:32Z dim $

.include <bsd.init.mk>

LIB=		clang_rt.msan_cxx-${CRTARCH}

SRCS+=		msan/msan_new_delete.cc
SRCS+=		ubsan/ubsan_handlers_cxx.cc
SRCS+=		ubsan/ubsan_type_hash.cc
SRCS+=		ubsan/ubsan_type_hash_itanium.cc

.include <bsd.lib.mk>

CXXFLAGS.ubsan_handlers_cxx.cc=		-frtti
CXXFLAGS.ubsan_type_hash.cc=		-frtti
CXXFLAGS.ubsan_type_hash_itanium.cc=	-frtti
