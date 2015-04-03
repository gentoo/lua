# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit eutils toolchain-funcs versionator

MY_P=${PN}-$(replace_version_separator 3 'r' )

DESCRIPTION="Lua bindings to Thomas Boutell's gd library"
HOMEPAGE="http://lua-gd.luaforge.net/"
SRC_URI="http://luaforge.net/frs/download.php/1592/${MY_P}.tar.gz
	mirror://sourceforge/${PN}/${PN}/${MY_P}%20%28for%20Lua%205.1%29/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc examples luajit"

RDEPEND="
	luajit? ( dev-lang/luajit:2 )
	!luajit? ( >=dev-lang/lua-5.1 )
	media-libs/gd[png]
"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S=${WORKDIR}/${MY_P}

src_prepare() {
	epatch "${FILESDIR}/${P}-makefile.patch"
}

src_compile() {
	local lua=lua;
	use luajit && lua=luajit;
	emake LUAPKG="${lua}" LUABIN="${lua}" CC="$(tc-getCC)"
}

src_install() {
	local lua=lua;
	use luajit && lua=luajit;
	emake \
		LUAPKG="${lua}"\
		DESTDIR="${D}"\
		INSTALL_PATH="$($(tc-getPKG_CONFIG) --variable INSTALL_CMOD ${lua})"\
		install
	dodoc README

	if use doc; then
		dohtml doc/*
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r demos
	fi
}
