# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="4"

inherit cmake-utils git-2

DESCRIPTION="A minimal set of XML processing function in Lua, with simple mapping between XML and Lua tables"
HOMEPAGE="http://github.com/LuaDist/luaxml"
EGIT_REPO_URI="git://github.com/LuaDist/luaxml.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="luajit"

RDEPEND="|| ( >=dev-lang/lua-5.1 dev-lang/luajit:2 )"
DEPEND="${RDEPEND}
		dev-util/pkgconfig"

src_configure() {
	local LUA="lua"
	use luajit && LUA="luajit"
	mycmakeargs=(
		-DINSTALL_CMOD=$($(tc-getPKG_CONFIG) --variable INSTALL_CMOD ${LUA}) \
		-DINSTALL_LMOD=$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD ${LUA})
	)
	cmake-utils_src_configure
}