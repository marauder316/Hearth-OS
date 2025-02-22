# $FreeBSD: stable/11/lib/clang/clang.build.mk 310618 2016-12-26 20:36:37Z dim $

.include <src.opts.mk>

.ifndef LLVM_SRCS
.error Please define LLVM_SRCS before including this file
.endif

.ifndef CLANG_SRCS
.error Please define CLANG_SRCS before including this file
.endif

.ifndef SRCDIR
.error Please define SRCDIR before including this file
.endif

CFLAGS+=	-I${CLANG_SRCS}/include

.if ${MK_CLANG_FULL} != "no"
CFLAGS+=	-DCLANG_ENABLE_ARCMT
CFLAGS+=	-DCLANG_ENABLE_STATIC_ANALYZER
.endif

.include "llvm.build.mk"
