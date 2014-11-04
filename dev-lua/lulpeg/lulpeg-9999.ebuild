# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit toolchain-funcs git-r3

DESCRIPTION="A pure Lua port of LPeg, Roberto Ierusalimschy's Parsing Expression Grammars library"
HOMEPAGE="https://github.com/pygy/LuLPeg"
SRC_URI=""

EGIT_REPO_URI="https://github.com/pygy/LuLPeg"

LICENSE="WTFPL"
SLOT="0"
KEYWORDS=""
IUSE="luajit +lpeg_replace"

RDEPEND="
	luajit? ( dev-lang/luajit:2 )
	!luajit? ( >=dev-lang/lua-5.1 )
	lpeg_replace? ( !dev-lua/lpeg )
"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch_user
}

src_install() {
	local pkg_n=lulpeg
	local lua=lua
	use luajit && lua=luajit

	use lpeg_replace && pkg_n=lpeg

	mv src "${pkg_n}"

	insinto "$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD ${lua})"
	doins -r "${pkg_n}"

	dodoc README.md TODO.md ABOUT || die "dodoc failed"
}
