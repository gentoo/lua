# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"
inherit multilib eutils git-r3 toolchain-funcs

DESCRIPTION="File System Library for the Lua Programming Language"
HOMEPAGE="http://keplerproject.github.com/luafilesystem/"
EGIT_REPO_URI="git://github.com/keplerproject/luafilesystem.git"
SRC_URI=""
#SRC_URI="https://github.com/downloads/keplerproject/luafilesystem/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc luajit"

DEPEND="virtual/lua[luajit=]"
RDEPEND="${DEPEND}"

DOCS=( README )

src_prepare() {
	sed \
		-e "s|/usr/local|/usr|" \
		-e "s|/lib|/$(get_libdir)|" \
		-e "s|-O2|${CFLAGS}|" \
		-e "/^LIB_OPTION/s|= |= ${LDFLAGS} |" \
		-e "s|gcc|$(tc-getCC)|" \
		-i config || die "config fix failed"
	use luajit && sed -r \
		-e "s|(LUA_INC)=.*|\1 = $($(tc-getPKG_CONFIG) luajit --variable includedir)|" \
		-i config || die "luajit include fix failed"
}

src_install() {
	emake PREFIX="${ED}usr" install
	use doc && dohtml doc/us/*
}
