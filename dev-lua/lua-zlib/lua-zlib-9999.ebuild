# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS="git"
GITHUB_A="brimworks"

inherit lua

DESCRIPTION="Lua bindings to zlib"
HOMEPAGE="http://github.com/brimworks/lua-zlib"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="sys-libs/zlib"
DEPEND="${RDEPEND}"

each_lua_configure() {
	local myeconfargs=(
		INCDIR=""
		LIBDIR=""
	)
	lua_default
}

each_lua_compile() {
	lua_default linux
}

each_lua_install() {
	dolua "${PN//lua-}".so
}
