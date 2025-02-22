/*-
 * Copyright (c) 2009 Michihiro NAKAJIMA
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions
 * are met:
 * 1. Redistributions of source code must retain the above copyright
 *    notice, this list of conditions and the following disclaimer
 *    in this position and unchanged.
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
__FBSDID("$FreeBSD: stable/11/contrib/libarchive/libarchive/test/test_write_format_mtree.c 299529 2016-05-12 10:16:16Z mm $");

static char buff[4096];
static struct {
	const char	*path;
	mode_t		 mode;
	time_t		 mtime;
	uid_t	 	 uid;
	gid_t		 gid;
} entries[] = {
	{ "./COPYING",		S_IFREG | 0644, 1231975636, 1001, 1001 },
	{ "./Makefile", 	S_IFREG | 0644, 1233041050, 1001, 1001 },
	{ "./NEWS", 		S_IFREG | 0644, 1231975636, 1001, 1001 },
	{ "./PROJECTS", 	S_IFREG | 0644, 1231975636, 1001, 1001 },
	{ "./README",		S_IFREG | 0644, 1231975636, 1001, 1001 },
	{ "./subdir",		S_IFDIR | 0755, 1233504586, 1001, 1001 },
	{ "./subdir/README",	S_IFREG | 0664, 1231975636, 1002, 1001 },
	{ "./subdir/config",	S_IFREG | 0664, 1232266273, 1003, 1003 },
	{ "./subdir2",		S_IFDIR | 0755, 1233504586, 1001, 1001 },
	{ "./subdir3",		S_IFDIR | 0755, 1233504586, 1001, 1001 },
	{ "./subdir3/mtree",	S_IFREG | 0664, 1232266273, 1003, 1003 },
	{ NULL, 0, 0, 0, 0 }
};
static struct {
  const char  *path;
  mode_t     mode;
  time_t     mtime;
  uid_t    uid;
  gid_t    gid;
} entries2[] = {
  { "COPYING",    S_IFREG | 0644, 1231975636, 1001, 1001 },
  { "Makefile",   S_IFREG | 0644, 1233041050, 1001, 1001 },
  { "NEWS",     S_IFREG | 0644, 1231975636, 1001, 1001 },
  { "PROJECTS",   S_IFREG | 0644, 1231975636, 1001, 1001 },
  { "README",   S_IFREG | 0644, 1231975636, 1001, 1001 },
  { "subdir",   S_IFDIR | 0755, 1233504586, 1001, 1001 },
  { "subdir/README",  S_IFREG | 0664, 1231975636, 1002, 1001 },
  { "subdir/config",  S_IFREG | 0664, 1232266273, 1003, 1003 },
  { "subdir2",    S_IFDIR | 0755, 1233504586, 1001, 1001 },
  { "subdir3",    S_IFDIR | 0755, 1233504586, 1001, 1001 },
  { "subdir3/mtree",  S_IFREG | 0664, 1232266273, 1003, 1003 },
  { NULL, 0, 0, 0, 0 }
};

static void
test_write_format_mtree_sub(int use_set, int dironly)
{
	struct archive_entry *ae;
	struct archive* a;
	size_t used;
	int i;

	/* Create a mtree format archive. */
	assert((a = archive_write_new()) != NULL);
	assertEqualIntA(a, ARCHIVE_OK, archive_write_set_format_mtree(a));
	if (use_set)
		assertEqualIntA(a, ARCHIVE_OK, archive_write_set_format_option(a, NULL, "use-set", "1"));
	if (dironly)
		assertEqualIntA(a, ARCHIVE_OK, archive_write_set_format_option(a, NULL, "dironly", "1"));
	assertEqualIntA(a, ARCHIVE_OK, archive_write_open_memory(a, buff, sizeof(buff)-1, &used));

	/* Write entries */
	for (i = 0; entries[i].path != NULL; i++) {
		assert((ae = archive_entry_new()) != NULL);
		archive_entry_set_mtime(ae, entries[i].mtime, 0);
		assert(entries[i].mtime == archive_entry_mtime(ae));
		archive_entry_set_mode(ae, entries[i].mode);
		assert(entries[i].mode == archive_entry_mode(ae));
		archive_entry_set_uid(ae, entries[i].uid);
		assert(entries[i].uid == archive_entry_uid(ae));
		archive_entry_set_gid(ae, entries[i].gid);
		assert(entries[i].gid == archive_entry_gid(ae));
		archive_entry_copy_pathname(ae, entries[i].path);
		if ((entries[i].mode & AE_IFMT) != S_IFDIR)
			archive_entry_set_size(ae, 8);
		assertEqualIntA(a, ARCHIVE_OK, archive_write_header(a, ae));
		if ((entries[i].mode & AE_IFMT) != S_IFDIR)
			assertEqualIntA(a, 8,
			    archive_write_data(a, "Hello012", 15));
		archive_entry_free(ae);
	}
	assertEqualIntA(a, ARCHIVE_OK, archive_write_close(a));
        assertEqualInt(ARCHIVE_OK, archive_write_free(a));

	if (use_set) {
		const char *p;

		buff[used] = '\0';
		assert(NULL != (p = strstr(buff, "\n/set ")));
		if (p != NULL) {
			char *r;
			const char *o;
			p++;
			r = strchr(p, '\n');
			if (r != NULL)
				*r = '\0';
			if (dironly)
				o = "/set type=dir uid=1001 gid=1001 mode=755";
			else
				o = "/set type=file uid=1001 gid=1001 mode=644";
			assertEqualString(o, p);
			if (r != NULL)
				*r = '\n';
		}
	}

	/*
	 * Read the data and check it.
	 */
	assert((a = archive_read_new()) != NULL);
	assertEqualIntA(a, ARCHIVE_OK, archive_read_support_format_all(a));
	assertEqualIntA(a, ARCHIVE_OK, archive_read_support_filter_all(a));
	assertEqualIntA(a, ARCHIVE_OK, archive_read_open_memory(a, buff, used));

	/* Read entries */
	for (i = 0; entries[i].path != NULL; i++) {
		if (dironly && (entries[i].mode & AE_IFMT) != S_IFDIR)
			continue;
		assertEqualIntA(a, ARCHIVE_OK, archive_read_next_header(a, &ae));
		assertEqualInt(entries[i].mtime, archive_entry_mtime(ae));
		assertEqualInt(entries[i].mode, archive_entry_mode(ae));
		assertEqualInt(entries[i].uid, archive_entry_uid(ae));
		assertEqualInt(entries[i].gid, archive_entry_gid(ae));
		assertEqualString(entries[i].path, archive_entry_pathname(ae));
		if ((entries[i].mode & AE_IFMT) != S_IFDIR)
			assertEqualInt(8, archive_entry_size(ae));
	}
	assertEqualIntA(a, ARCHIVE_OK, archive_read_close(a));
	assertEqualInt(ARCHIVE_OK, archive_read_free(a));
}

static void
test_write_format_mtree_sub2(int use_set, int dironly)
{
  struct archive_entry *ae;
  struct archive* a;
  size_t used;
  int i;
  char str[32];

  /* Create a mtree format archive. */
  assert((a = archive_write_new()) != NULL);
  assertEqualIntA(a, ARCHIVE_OK, archive_write_set_format_mtree(a));
  if (use_set)
    assertEqualIntA(a, ARCHIVE_OK, archive_write_set_format_option(a, NULL, "use-set", "1"));
  if (dironly)
    assertEqualIntA(a, ARCHIVE_OK, archive_write_set_format_option(a, NULL, "dironly", "1"));
  assertEqualIntA(a, ARCHIVE_OK, archive_write_open_memory(a, buff, sizeof(buff)-1, &used));

  /* Write entries2 */
  for (i = 0; entries2[i].path != NULL; i++) {
    assert((ae = archive_entry_new()) != NULL);
    archive_entry_set_mtime(ae, entries2[i].mtime, 0);
    assert(entries2[i].mtime == archive_entry_mtime(ae));
    archive_entry_set_mode(ae, entries2[i].mode);
    assert(entries2[i].mode == archive_entry_mode(ae));
    archive_entry_set_uid(ae, entries2[i].uid);
    assert(entries2[i].uid == archive_entry_uid(ae));
    archive_entry_set_gid(ae, entries2[i].gid);
    assert(entries2[i].gid == archive_entry_gid(ae));
    archive_entry_copy_pathname(ae, entries2[i].path);
    if ((entries2[i].mode & AE_IFMT) != S_IFDIR)
      archive_entry_set_size(ae, 8);
    assertEqualIntA(a, ARCHIVE_OK, archive_write_header(a, ae));
    if ((entries2[i].mode & AE_IFMT) != S_IFDIR)
      assertEqualIntA(a, 8,
          archive_write_data(a, "Hello012", 15));
    archive_entry_free(ae);
  }
  assertEqualIntA(a, ARCHIVE_OK, archive_write_close(a));
        assertEqualInt(ARCHIVE_OK, archive_write_free(a));

  if (use_set) {
    const char *p;

    buff[used] = '\0';
    assert(NULL != (p = strstr(buff, "\n/set ")));
    if (p != NULL) {
      char *r;
      const char *o;
      p++;
      r = strchr(p, '\n');
      if (r != NULL)
        *r = '\0';
      if (dironly)
        o = "/set type=dir uid=1001 gid=1001 mode=755";
      else
        o = "/set type=file uid=1001 gid=1001 mode=644";
      assertEqualString(o, p);
      if (r != NULL)
        *r = '\n';
    }
  }

  /*
   * Read the data and check it.
   */
  assert((a = archive_read_new()) != NULL);
  assertEqualIntA(a, ARCHIVE_OK, archive_read_support_format_all(a));
  assertEqualIntA(a, ARCHIVE_OK, archive_read_support_filter_all(a));
  assertEqualIntA(a, ARCHIVE_OK, archive_read_open_memory(a, buff, used));

  /* Read entries2 */
  memset(str, 0, sizeof(str));
  strcpy(str, "./");
  for (i = 0; entries2[i].path != NULL; i++) {
    if (dironly && (entries2[i].mode & AE_IFMT) != S_IFDIR)
      continue;
    assertEqualIntA(a, ARCHIVE_OK, archive_read_next_header(a, &ae));
    assertEqualInt(entries2[i].mtime, archive_entry_mtime(ae));
    assertEqualInt(entries2[i].mode, archive_entry_mode(ae));
    assertEqualInt(entries2[i].uid, archive_entry_uid(ae));
    assertEqualInt(entries2[i].gid, archive_entry_gid(ae));
    strcpy(str + 2, entries2[i].path);
    assertEqualString(str, archive_entry_pathname(ae));
    if ((entries2[i].mode & AE_IFMT) != S_IFDIR)
      assertEqualInt(8, archive_entry_size(ae));
  }
  assertEqualIntA(a, ARCHIVE_OK, archive_read_close(a));
  assertEqualInt(ARCHIVE_OK, archive_read_free(a));
}

DEFINE_TEST(test_write_format_mtree)
{
	/* Default setting */
	test_write_format_mtree_sub(0, 0);
	/* Directory only */
	test_write_format_mtree_sub(0, 1);
	/* Use /set keyword */
	test_write_format_mtree_sub(1, 0);
	/* Use /set keyword with directory only */
	test_write_format_mtree_sub(1, 1);
}

DEFINE_TEST(test_write_format_mtree_no_leading_dotslash)
{
  /* Default setting */
  test_write_format_mtree_sub2(0, 0);
  /* Directory only */
  test_write_format_mtree_sub2(0, 1);
  /* Use /set keyword */
  test_write_format_mtree_sub2(1, 0);
  /* Use /set keyword with directory only */
  test_write_format_mtree_sub2(1, 1);
}
