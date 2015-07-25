# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit eutils toolchain-funcs git-r3

DESCRIPTION="A small Lua interface to Sentry"
HOMEPAGE="https://github.com/cloudflare/${PN}-lua"
SRC_URI=""

EGIT_REPO_URI="https://github.com/cloudflare/${PN}-lua"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="luajit"

RDEPEND="
	virtual/lua[luajit=]
	dev-lua/lunit
	dev-lua/luaposix
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

src_compile() { :; }

src_install() {
	local lua=lua;
	use luajit && lua=luajit;

	insinto "$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD ${lua})"
	doins -r raven.lua

	dodoc -r README.md
	dohtml docs/*
}
