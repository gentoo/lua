# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

VCS="git-r3"
IS_MULTILIB=true

LUA_COMPAT="lua51 luajit2"

inherit cmake-utils lua

DESCRIPTION="A minimal set of XML processing function in Lua, with simple mapping between XML and Lua tables"
HOMEPAGE="http://github.com/LuaDist/luaxml"
EGIT_REPO_URI="https://github.com/msva/luaxml"

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

