--
-- SPDX-License-Identifier: BSD-2-Clause-FreeBSD
--
-- Copyright (c) 2018 Kyle Evans <kevans@FreeBSD.org>
-- All rights reserved.
--
-- Redistribution and use in source and binary forms, with or without
-- modification, are permitted provided that the following conditions
-- are met:
-- 1. Redistributions of source code must retain the above copyright
--    notice, this list of conditions and the following disclaimer.
-- 2. Redistributions in binary form must reproduce the above copyright
--    notice, this list of conditions and the following disclaimer in the
--    documentation and/or other materials provided with the distribution.
--
-- THIS SOFTWARE IS PROVIDED BY THE AUTHOR AND CONTRIBUTORS ``AS IS'' AND
-- ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
-- IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
-- ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR CONTRIBUTORS BE LIABLE
-- FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
-- DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
-- OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
-- HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
-- LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
-- OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
-- SUCH DAMAGE.
--
-- $FreeBSD: stable/11/stand/lua/logo-orb.lua 344220 2019-02-17 02:39:17Z kevans $
--

local drawer = require("drawer")

local orb_color = {
"  \027[31m```                        \027[31;1m`\027[31m",
" s` `.....---...\027[31;1m....--.```   -/\027[31m",
" +o   .--`         \027[31;1m/y:`      +.\027[31m",
"  yo`:.            \027[31;1m:o      `+-\027[31m",
"   y/               \027[31;1m-/`   -o/\027[31m",
"  .-                  \027[31;1m::/sy+:.\027[31m",
"  /                     \027[31;1m`--  /\027[31m",
" `:                          \027[31;1m:`\027[31m",
" `:                          \027[31;1m:`\027[31m",
"  /                          \027[31;1m/\027[31m",
"  .-                        \027[31;1m-.\027[31m",
"   --                      \027[31;1m-.\027[31m",
"    `:`                  \027[31;1m`:`",
"      \027[31;1m.--             `--.",
"         .---.....----.\027[37m"
}

drawer.addLogo("orb", {
	requires_color = true,
	graphic = orb_color,
	shift = {x = 2, y = 4},
})

return true
