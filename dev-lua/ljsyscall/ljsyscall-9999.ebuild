# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

VCS="git-r3"
LUA_COMPAT="luajit2"
inherit lua

DESCRIPTION="LuaJIT Unix syscall FFI"
HOMEPAGE="https://github.com/justincormack/ljsyscall"
SRC_URI=""

EGIT_REPO_URI="https://github.com/justincormack/ljsyscall"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc +examples test"

RDEPEND="
	virtual/libc
"
DEPEND="${RDEPEND}"

DOCS=( README.md doc/)
EXAMPLES=( examples/* )

each_lua_install() {
	dolua syscall syscall.lua
}
