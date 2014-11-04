# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit eutils toolchain-funcs git-r3

DESCRIPTION="A LuaDoc-compatible documentation generation system"
HOMEPAGE="https://github.com/stevedonovan/LDoc/"
SRC_URI=""

EGIT_REPO_URI="https://github.com/stevedonovan/LDoc/"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="luajit doc"

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
		-e "1s#(/usr/bin/env).*#\1 ${lua}#" \
		-i ldoc.lua
}

src_compile() { :; }

src_install() {
	local lua=lua
	use luajit && lua=luajit

	insinto "$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD ${lua})"
	doins -r ldoc ldoc.lua

	newbin ldoc.lua ldoc
}
