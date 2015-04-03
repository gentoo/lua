# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit multilib
DESCRIPTION="LuaDoc is a documentation tool for Lua source code"
HOMEPAGE="http://luadoc.luaforge.net/"
SRC_URI="http://luaforge.net/frs/download.php/3185/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm ppc ppc64 x86 ~x86-fbsd"
IUSE="luajit"

DEPEND=""
RDEPEND="
	!luajit? ( >=dev-lang/lua-5.1.3 )
	luajit? ( dev-lang/luajit:2 )
	dev-lua/luafilesystem"

src_prepare() {
	cd "${S}"
	sed \
		-e "s|/usr/local|\$(DESTDIR)/usr|" \
		-e "s|lib|$(get_libdir)|" \
		-e "s|lua5.1|lua|" \
		-i config || die

	use luajit && sed \
		-e "s|#!/usr/bin/env lua|#! /usr/bin/env luajit|" \
		-i src/luadoc.lua.in

	# lua-5.1.3
	find . -name '*.lua' | xargs sed -i -e "s/gfind/gmatch/g" || die

}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc README
	dohtml -r doc/us/*
}
