# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

IS_MULTILIB=true
LUA_COMPAT="lua51 luajit2"
inherit lua

DESCRIPTION="Parsing Expression Grammars for Lua"
HOMEPAGE="http://www.inf.puc-rio.br/~roberto/lpeg/"
SRC_URI="http://www.inf.puc-rio.br/~roberto/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ~mips x86"
IUSE="debug doc"

PATCHES=( "${FILESDIR}"/${P}-makefile.patch )
DOCS=( HISTORY )
HTML_DOCS=( {lpeg,re}.html )

all_lua_prepare() {
	use debug && append-cflags -DLPEG_DEBUG
}

each_lua_compile() {
	lua_default DLLFLAGS="${CFLAGS} ${LDFLAGS}" lpeg.so
}

each_lua_test() {
	${LUA} test.lua
}

each_lua_install() {
	dolua lpeg.so
}
