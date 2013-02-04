# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="4"

inherit cmake-utils git-2

DESCRIPTION="Lua bindings to libzip"
HOMEPAGE="http://github.com/brimworks/lua-zip"
EGIT_REPO_URI="git://github.com/brimworks/lua-zip.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="luajit"

RDEPEND="|| ( >=dev-lang/lua-5.1 dev-lang/luajit:2 )
		dev-libs/libzip"
DEPEND="${RDEPEND}
		dev-util/pkgconfig"

src_prepare() {
	mv *-${PN}-* "${S}"
}

src_configure() {
	local LUA="lua"
	use luajit && LUA="luajit"
	MYCMAKEARGS="-DINSTALL_CMOD='$(pkg-config --variable INSTALL_CMOD ${LUA})'"
	cmake-utils_src_configure
}