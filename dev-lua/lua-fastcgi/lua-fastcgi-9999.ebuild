# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit toolchain-funcs eutils git-r3

DESCRIPTION="A FastCGI server for Lua, written in C"
HOMEPAGE="https://github.com/cramey/lua-fastcgi"
SRC_URI=""

EGIT_REPO_URI="https://github.com/cramey/lua-fastcgi.git"
EGIT_BRANCH="public"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc luajit"

RDEPEND="
	virtual/lua[luajit]
	dev-libs/fcgi
"
DEPEND="${RDEPEND}"

src_prepare() {
	local lua=lua
	use luajit && lua=luajit

	LUA_LIB="$($(tc-getPKG_CONFIG) libs ${lua})"

	sed -r \
		-e "s#^(CFLAGS=.*)#\1 $($(tc-getPKG_CONFIG) --variable cflags ${lua})#" \
		-e "s/-Wl,[^ ]*//g" \
		-e "s#-llua5.1#${LUA_LIB}#g" \
		-i Makefile
	sed \
		-e "s#lua5.1/##" \
		-i src/config.c src/lfuncs.c src/lua.c src/lua-fastcgi.c
}

src_install() {
	if use doc; then
		dodoc README.md TODO lua-fastcgi.lua || die "dodoc failed"
	fi
	dobin lua-fastcgi
}
