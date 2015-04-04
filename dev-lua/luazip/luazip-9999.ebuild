# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit git-r3 toolchain-funcs

DESCRIPTION="Lua bindings to zziplib"
HOMEPAGE="https://github.com/luaforge/luazip"
EGIT_REPO_URI="https://github.com/luaforge/luazip.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="luajit"

RDEPEND="
	virtual/lua[luajit=]
	dev-libs/zziplib
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

src_configure() {
	local lua=lua;
	use luajit && lua=luajit;
	sed -r \
		-e "s#(LUA_INC)=.*#\1=$($(tc-getPKG_CONFIG) --variable includedir ${lua})#" \
		-e 's#(PREFIX) =.*#\1=$(DESTDIR)/usr#' \
		-e "s#(ZZLIB_INC)=.*#\1=/usr/include#" \
		-e "s#(LUA_VERSION_NUM)=.*#\1=510#" \
		-i config
}
