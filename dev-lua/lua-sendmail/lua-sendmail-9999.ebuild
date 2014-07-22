# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit base toolchain-funcs git-r3

DESCRIPTION="A stream-based HTML template library for Lua."
HOMEPAGE="https://github.com/moteus/lua-sendmail"
SRC_URI=""

EGIT_REPO_URI="https://github.com/moteus/lua-sendmail"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="luajit"

RDEPEND="
	!luajit? ( >=dev-lang/lua-5.1 )
	luajit?  ( dev-lang/luajit:2 )
	dev-lua/luasocket
"
DEPEND="
	${RDEPEND}
	dev-util/pkgconfig
"

HTML_DOCS=( "docs/" )

src_install() {
	local lua=lua;
	use luajit && lua=luajit;

	insinto "$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD ${lua})"
	doins lua/sendmail.lua

	base_src_install_docs
}
