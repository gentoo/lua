# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

VCS="git-r3"
IS_MULTILIB=true
LUA_COMPAT="lua51 luajit2"
inherit cmake-utils lua

DESCRIPTION="Lua JSON Library, written in C"
HOMEPAGE="http://www.kyne.com.au/~mark/software/lua-cjson.php"
SRC_URI=""

EGIT_REPO_URI="https://github.com/openresty/lua-cjson"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="+examples"

EXAMPLES=( tests/ lua/{json2lua,lua2json}.lua )

each_lua_configure() {
	mycmakeargs=(
		-DUSE_INTERNAL_FPCONV=ON
	)
	cmake-utils_src_configure
}

each_lua_install() {
	dolua lua/cjson cjson.so
#	cmake-utils_src_install
}
