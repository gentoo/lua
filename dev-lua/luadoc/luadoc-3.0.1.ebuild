# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit multilib toolchain-funcs
DESCRIPTION="LuaDoc is a documentation tool for Lua source code"
HOMEPAGE="http://keplerproject.github.io/luadoc/"
SRC_URI="http://luaforge.net/frs/download.php/3185/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm ppc ppc64 x86 ~x86-fbsd"
IUSE="luajit"

DEPEND=""
RDEPEND="
	virtual/lua[luajit=]
	dev-lua/luafilesystem
"

src_prepare() {
	local lua=lua;
	use luajit && lua=luajit;

	echo "
		PREFIX=/usr
		LUA_LIBDIR=$($(tc-getPKG_CONFIG) --variable INSTALL_CMOD ${lua})
		LUA_DIR=$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD ${lua})
		SYS_BINDIR= ${EROOT}/usr/bin
	" > "${S}/config"

	sed -r \
		-e "1s|^(#!.* ) lua|\1 ${lua}|" \
		-i src/luadoc.lua.in

	# lua-5.1.3
	find . -name '*.lua' | xargs sed -e "s/gfind/gmatch/g" -i || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc README
	dohtml -r doc/us/*
}
