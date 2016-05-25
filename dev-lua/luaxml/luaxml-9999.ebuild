# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS="git"
IS_MULTILIB=true
LUA_COMPAT="lua51 luajit2"

GITHUB_A="msva"

inherit cmake-utils lua

DESCRIPTION="A minimal set of XML processing function in Lua, with simple mapping between XML and Lua tables"
HOMEPAGE="http://viremo.eludi.net/LuaXML/"
#EGIT_REPO_URI="https://github.com/msva/luaxml"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

each_lua_configure() {
	mycmakeargs=(
		-DINSTALL_CMOD="$(lua_get_pkgvar INSTALL_CMOD)"
		-DINSTALL_LMOD="$(lua_get_pkgvar INSTALL_LMOD)"
	)

	cmake-utils_src_configure
}

