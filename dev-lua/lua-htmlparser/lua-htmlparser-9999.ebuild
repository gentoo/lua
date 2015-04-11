# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI=5

inherit toolchain-funcs eutils git-r3

DESCRIPTION="Parse HTML text into a tree of elements with selectors"
HOMEPAGE="https://github.com/wscherphof/lua-htmlparser"
SRC_URI=""

EGIT_REPO_URI="https://github.com/wscherphof/lua-htmlparser"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="luajit"

DEPEND="
	virtual/lua[luajit=]
	virtual/pkgconfig
"
RDEPEND="
	${DEPEND}
"

src_install() {
	local lua="lua";
	use luajit && lua="luajit";
	insinto "$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD ${lua})"
	doins -r src/*
}
