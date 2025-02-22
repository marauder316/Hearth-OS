/*-
 * Copyright (c) 2003-2014 Tim Kientzle
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer.
 * 2. Redistributions in binary form must reproduce the above copyright
 *    notice, this list of conditions and the following disclaimer in the
 *    documentation and/or other materials provided with the distribution.
 *
 * THIS SOFTWARE IS PROVIDED BY THE AUTHOR(S) ``AS IS'' AND ANY EXPRESS OR
 * IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 * OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 * IN NO EVENT SHALL THE AUTHOR(S) BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 * DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 * THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 * (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
 * THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
#include "test.h"
__FBSDID("$FreeBSD: stable/11/contrib/libarchive/tar/test/test_leading_slash.c 310569 2016-12-26 06:16:27Z ngie $");

DEFINE_TEST(test_leading_slash)
{
	const char *reffile = "test_leading_slash.tar";
	char *errfile;
	size_t errfile_size;
	const char *expected_errmsg = "Removing leading '/' from member names";

	extract_reference_file(reffile);
	assertEqualInt(0, systemf("%s -xf %s >test.out 2>test.err", testprog, reffile));
	assertFileExists("foo/file");
	assertTextFileContents("foo\x0a", "foo/file");
	assertTextFileContents("foo\x0a", "foo/hardlink");
	assertIsHardlink("foo/file", "foo/hardlink");
	assertEmptyFile("test.out");

	/* Verify the error output contains the expected text somewhere in it */
	if (assertFileExists("test.err")) {
		errfile = slurpfile(&errfile_size, "test.err");
		assert(strstr(errfile, expected_errmsg) != NULL);
		free(errfile);
	}
}

