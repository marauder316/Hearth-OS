# $FreeBSD: stable/11/lib/libclang_rt/Makefile 347396 2019-05-09 17:02:40Z ngie $

.include <src.opts.mk>

.if ${MACHINE_CPUARCH} == "i386" || ${MACHINE_CPUARCH} == "amd64"
SUBDIR+=	include
SUBDIR+=	asan
SUBDIR+=	asan-preinit
SUBDIR+=	asan_cxx
SUBDIR+=	asan_dynamic
.if ${MACHINE_CPUARCH} == "amd64"
SUBDIR+=	msan
SUBDIR+=	msan_cxx
.endif
SUBDIR+=	safestack
SUBDIR+=	stats
SUBDIR+=	stats_client
.if ${MACHINE_CPUARCH} == "amd64"
SUBDIR+=	tsan
SUBDIR+=	tsan_cxx
.endif
SUBDIR+=	ubsan_minimal
SUBDIR+=	ubsan_standalone
SUBDIR+=	ubsan_standalone_cxx
.endif

SUBDIR+=	profile

.include <bsd.subdir.mk>
