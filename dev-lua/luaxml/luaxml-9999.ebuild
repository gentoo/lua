# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit cmake-utils git-r3

DESCRIPTION="A minimal set of XML processing function in Lua, with simple mapping between XML and Lua tables"
HOMEPAGE="http://github.com/LuaDist/luaxml"
EGIT_REPO_URI="https://github.com/msva/luaxml"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="luajit"

RDEPEND="
	!luajit? ( >=dev-lang/lua-5.1 )
	luajit? ( dev-lang/luajit:2 )
"
DEPEND="${RDEPEND}
		dev-util/pkgconfig"

src_configure() {
	local lua="lua"
	use luajit && lua="luajit"
	mycmakeargs=(
		-DINSTALL_CMOD=$($(tc-getPKG_CONFIG) --variable INSTALL_CMOD ${lua}) \
		-DINSTALL_LMOD=$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD ${lua})
	)
	cmake-utils_src_configure
}
