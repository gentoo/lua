# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

VCS="git-r3"
IS_MULTILIB="true"
inherit lua

DESCRIPTION="File System Library for the Lua Programming Language"
HOMEPAGE="https://keplerproject.github.io/luafilesystem/"
EGIT_REPO_URI="https://github.com/keplerproject/luafilesystem.git"
SRC_URI=""
#SRC_URI="https://github.com/downloads/keplerproject/luafilesystem/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc"

HTML_DOCS=( doc/us/ )
READMES=( README )

all_lua_prepare() {
	sed \
		-e 's|-O2|${CFLAGS}|' \
		-e '/^LIB_OPTION/s|= |= ${LDFLAGS} |' \
		-i config || die "config fix failed"
}

each_lua_install() {
	dolua src/lfs.so
}
