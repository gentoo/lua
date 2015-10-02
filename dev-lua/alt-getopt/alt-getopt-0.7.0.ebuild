# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit lua

DESCRIPTION="Lua bindings to getopt_long"
HOMEPAGE="http://luaforge.net/projects/alt-getopt"
MY_P="lua-${P}"
SRC_URI="mirror://luaforge/${PN}/${PN}/${P}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

READMES=( README )

S="${WORKDIR}/all/${MY_P}"
LUA_S="${MY_P}"

each_lua_compile() { :; }

each_lua_install() {
	dolua alt_getopt.lua
}

all_lua_install() {
	dobin alt_getopt
}
