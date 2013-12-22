# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit base toolchain-funcs git-r3

DESCRIPTION="A simple Lua function for printing to the console in color."
HOMEPAGE="https://github.com/kikito/ansicolors.lua"
SRC_URI=""

EGIT_REPO_URI="https://github.com/kikito/ansicolors.lua"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="luajit"

RDEPEND="
	!luajit? ( >=dev-lang/lua-5.1 )
	luajit?  ( dev-lang/luajit:2 )
"
DEPEND="
	${RDEPEND}
	dev-util/pkgconfig
"

HTML_DOCS=( "README.textile" )

src_install() {
	local lua=lua;
	use luajit && lua=luajit;

	insinto "$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD ${lua})"
	doins -r ansicolors.lua

	base_src_install_docs
}