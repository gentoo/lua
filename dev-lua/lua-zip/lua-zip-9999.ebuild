# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit cmake-utils git-r3

DESCRIPTION="Lua bindings to libzip"
HOMEPAGE="http://github.com/brimworks/lua-zip"
EGIT_REPO_URI="git://github.com/brimworks/lua-zip.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="luajit"

RDEPEND="
	virtual/lua[luajit=]
	dev-libs/libzip"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	mv *-${PN}-* "${S}"
}

src_configure() {
	local lua="lua"
	use luajit && lua="luajit"
	MYCMAKEARGS="-DINSTALL_CMOD='$($(tc-getPKG_CONFIG) --variable INSTALL_CMOD ${lua})'"
	cmake-utils_src_configure
}
