# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit base multilib toolchain-funcs git-r3

DESCRIPTION="Allows Lua scripts to call external processes while capturing both their input and output."
HOMEPAGE="http://lua.net-core.org/sputnik.lua?p=Telesto:About"
EGIT_REPO_URI="https://github.com/LuaDist/lpc"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="luajit"

RDEPEND="|| ( >=dev-lang/lua-5.1 dev-lang/luajit:2 )"
DEPEND="${RDEPEND}"

src_compile() {
	local lua=lua;
	use luajit && lua=luajit;
	emake CFLAGS="-I$($(tc-getPKG_CONFIG) --variable includedir ${lua}) -fPIC" CC="$(tc-getCC)"
}

src_install() {
	local lua=lua;
	use luajit && lua=luajit;
	emake INSTALL_PREFIX="${D}$($(tc-getPKG_CONFIG) --variable INSTALL_CMOD ${lua})" install
}
