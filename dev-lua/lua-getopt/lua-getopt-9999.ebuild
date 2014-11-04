# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit toolchain-funcs git-r3

DESCRIPTION="Lua getopt module (simplified)"
HOMEPAGE="https://github.com/jjensen/lua-getopt"
EGIT_REPO_URI="https://github.com/jjensen/lua-getopt"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="luajit"

RDEPEND="
	!luajit? ( dev-lang/lua )
	luajit? ( dev-lang/luajit:2 )
"
DEPEND="
	${RDEPEND}
	dev-util/pkgconfig
"


src_install() {
	local lua=lua;
	use luajit && lua=luajit;
	insinto "$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD ${lua})"
	doins src/getopt.lua
}
