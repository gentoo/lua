# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit flag-o-matic toolchain-funcs eutils multilib

DESCRIPTION="Parsing Expression Grammars for Lua"
HOMEPAGE="http://www.inf.puc-rio.br/~roberto/lpeg/"
SRC_URI="http://www.inf.puc-rio.br/~roberto/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ~mips x86"
IUSE="debug doc luajit"

RDEPEND="
	luajit? ( dev-lang/luajit:2 )
	!luajit? ( >=dev-lang/lua-5.1 )
"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	local lua=lua
	use luajit && lua=luajit

	epatch "${FILESDIR}"/${P}-makefile.patch
	sed -r \
		-e "2s#^(LUADIR).*#\1 = $($(tc-getPKG_CONFIG) --variable includedir ${lua})#" \
		-i makefile
	use debug && append-cflags -DLPEG_DEBUG
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_test() {
	local lua=lua
	use luajit && lua=luajit

	${lua} test.lua || die
}

src_install() {
	local lua=lua
	use luajit && lua=luajit

	exeinto "$($(tc-getPKG_CONFIG) --variable INSTALL_CMOD ${lua})"
	doexe lpeg.so

	dodoc HISTORY

	use doc && dohtml *.html
}
