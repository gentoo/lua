# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit cmake-utils git-r3

DESCRIPTION="Lua bindings to zlib"
HOMEPAGE="http://github.com/brimworks/lua-zlib"
EGIT_REPO_URI="git://github.com/msva/lua-zlib.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="luajit"

RDEPEND="
	!luajit? ( >=dev-lang/lua-5.1 )
	luajit? ( dev-lang/luajit:2 )
	sys-libs/zlib
"
DEPEND="
	${RDEPEND}
	dev-util/pkgconfig
"

src_prepare() {
	mv *-${PN}-* "${S}"
}

src_configure() {
	local lua=lua;
	local mycmakeargs;
	use luajit && lua="luajit";
	mycmakeargs=(
		-DINSTALL_CMOD=$($(tc-getPKG_CONFIG) --variable INSTALL_CMOD ${lua})
	)
	cmake-utils_src_configure
}
