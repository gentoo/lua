# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit eutils git-2

DESCRIPTION="A FastCGI server for Lua, written in C"
HOMEPAGE="https://github.com/cramey/lua-fastcgi"
SRC_URI=""

EGIT_REPO_URI="git://github.com/cramey/lua-fastcgi.git"
EGIT_BRANCH="public"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc luajit"

RDEPEND="
	|| ( >=dev-lang/lua-5.1 dev-lang/luajit:2 )
	luajit? ( dev-lang/luajit:2 )
	dev-libs/fcgi
"
DEPEND="${RDEPEND}"

src_prepare() {
	if use luajit; then
	LUA_LIB="luajit-5.1"
	LUA_INC="luajit-2.0/"
	else
	LUA_LIB="lua"
	LUA_INC=""
	fi
	sed -e "s/-Wl,[^ ]*//g"  -i Makefile
	sed -e "s/lua5.1/${LUA_LIB}/g"  -i Makefile
	sed -e "s#lua5.1/#${LUA_INC}#" -i src/config.c
	sed -e "s#lua5.1/#${LUA_INC}#" -i src/lfuncs.c
	sed -e "s#lua5.1/#${LUA_INC}#" -i src/lua.c
	sed -e "s#lua5.1/#${LUA_INC}#" -i src/lua-fastcgi.c
}

src_install() {
	if use doc; then
		dodoc README.md TODO lua-fastcgi.lua || die "dodoc failed"
	fi
	dobin lua-fastcgi
}
