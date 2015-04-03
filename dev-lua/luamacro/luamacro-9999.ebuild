# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit eutils toolchain-funcs git-r3

DESCRIPTION="library and driver script for preprocessing and evaluating Lua code"
HOMEPAGE="https://github.com/stevedonovan/LuaMacro/"
SRC_URI=""

EGIT_REPO_URI="https://github.com/stevedonovan/LuaMacro/"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="luajit"

RDEPEND="
	luajit? ( dev-landg/luajit:2 )
	!luajit? ( >=dev-lang/lua-5.1 )
"
DEPEND="
	${RDEPEND}
	dev-util/pkgconfig
"

src_prepare() {
	local lua=lua
	use luajit && lua=luajit

	sed -r \
		-e "1s#(/usr/bin/env) lua#\1 ${lua}#" \
		-i luam
}


src_install() {
	local lua=lua
	use luajit && lua=luajit

	insinto "$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD ${lua})"
	doins -r macro macro.lua

	dobin luam
}
