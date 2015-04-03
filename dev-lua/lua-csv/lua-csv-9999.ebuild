# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit toolchain-funcs git-r3

DESCRIPTION="a Lua module for reading delimited text files"
HOMEPAGE="https://github.com/geoffleyland/lua-csv"
SRC_URI=""

EGIT_REPO_URI="https://github.com/geoffleyland/lua-csv"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="luajit +lpeg_replace"

RDEPEND="
	luajit? ( dev-lang/luajit:2 )
	!luajit? ( >=dev-lang/lua-5.1 )
"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch_user
}

src_install() {
	local lua=lua
	use luajit && lua=luajit

	insinto "$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD ${lua})"
	doins -r lua/csv.lua

	dodoc README.md || die "dodoc failed"
}
