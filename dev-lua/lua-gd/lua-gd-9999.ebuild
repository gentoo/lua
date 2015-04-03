# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit eutils toolchain-funcs git-r3 multilib

DESCRIPTION="Lua bindings to Thomas Boutell's gd library"
HOMEPAGE="http://lua-gd.luaforge.net/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/ittner/lua-gd.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc examples luajit"

RDEPEND="
	!luajit? ( >=dev-lang/lua-5.1 )
	luajit? ( dev-lang/luajit:2 )
	media-libs/gd[png]"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

QA_PREBUILT="usr/$(get_libdir)/*"
# ^ sorry for that, but upstream prestrips module, and it is impossible to ask
# pkgconfig here, since lua implementation is unknown atm

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
