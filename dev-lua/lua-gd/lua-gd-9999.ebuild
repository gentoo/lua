# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit eutils toolchain-funcs git-r3

DESCRIPTION="Lua bindings to Thomas Boutell's gd library"
HOMEPAGE="http://lua-gd.luaforge.net/"
SRC_URI=""
EGIT_REPO_URI="git://github.com/ittner/lua-gd.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc examples luajit"

RDEPEND="
	!luahit? ( >=dev-lang/lua-5.1 )
	luajit? ( dev-lang/luajit:2 )
	media-libs/gd[png]"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_prepare() {
	sed -r \
		-e "s/^(CFLAGS=)-O3 -Wall /\1/" \
		-i Makefile
}

src_compile() {
	local lua=lua;
	use luajit && lua=luajit;
	emake LUAPKG="${lua}" LUABIN="${lua}" CC="$(tc-getCC)"
}

src_install() {
	local lua=lua;
	use luajit && lua=luajit;
	emake install LUAPKG="${lua}" DESTDIR="${D}"
	dodoc README

	if use doc; then
		dohtml doc/*
	fi

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r demos
	fi
}
