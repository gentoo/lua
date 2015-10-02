# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

VCS="git-r3"
LUA_COMPAT="lua51 luajit2"
IS_MULTILIB=true
inherit lua

DESCRIPTION="Resty-DBD-Stream (RDS) parser for Lua written in C"
HOMEPAGE="https://github.com/openresty/lua-rds-parser"
SRC_URI=""

EGIT_REPO_URI="https://github.com/openresty/lua-${PN}"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

each_lua_configure() {
	myeconfargs=(
		"PREFIX=/usr"
		"LUA_LIB_DIR=$(lua_get_pkgvar INSTALL_CMOD)"
		"LUA_INCLUDE_DIR=$(lua_get_pkgvar includedir)"
	)
	lua_default
}

