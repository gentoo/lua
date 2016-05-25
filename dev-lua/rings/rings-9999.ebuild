# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

VCS="git-r3"
IS_MULTILIB=true
inherit lua

DESCRIPTION="Lua Rings Library"
HOMEPAGE="https://github.com/keplerproject/rings"
SRC_URI=""

#s/msva/keplerproject/ when they apply pull-request
EGIT_REPO_URI="git://github.com/msva/rings.git https://github.com/msva/rings.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

each_lua_configure() {
	myeconfargs=(
		PREFIX=/usr
		LIBNAME="${P}".so
		LUA_LIBDIR="$(lua_get_pkgvar INSTALL_CMOD)"
		LUA_DIR="$(lua_get_pkgvar INSTALL_LMOD)"
	)
	lua_default
}

