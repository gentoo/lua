# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit base toolchain-funcs git-r3

DESCRIPTION="Lua binding to media-libs/libharu (PDF generator)"
HOMEPAGE="https://github.com/jung-kurt/luahpdf"
SRC_URI=""

EGIT_REPO_URI="https://github.com/msva/luahpdf"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc luajit"

RDEPEND="
	virtual/lua[luajit=]
	media-libs/libharu
"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

DOCS=( README.md )

src_prepare() {
	local lua=lua;
	use luajit && lua=luajit;

	echo "\
		PREFIX=/usr
		LUALIB=$($(tc-getPKG_CONFIG) --libs ${lua})
		LUAINC=$($(tc-getPKG_CONFIG) --cflags ${lua})
		MODDIR=$($(tc-getPKG_CONFIG) --variable INSTALL_CMOD ${lua})
		DOCDIR=\$(PREFIX)/share/doc/${P}
		LUA=luajit
	" > .config
}
