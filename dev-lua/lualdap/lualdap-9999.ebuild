# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit base git-r3 toolchain-funcs

DESCRIPTION="Lua driver for LDAP"
HOMEPAGE="https://github.com/mwild1/lualdap/"
SRC_URI=""

EGIT_REPO_URI="https://github.com/mwild1/lualdap.git git://github.com/mwild1/lualdap.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="luajit"

RDEPEND="
	|| ( >=dev-lang/lua-5.1 dev-lang/luajit:2 )
	net-nds/openldap
"
DEPEND="${RDEPEND}"

DOCS=( "README" )

src_prepare() {
	local lua=lua;
	use luajit && lua=luajit;

	sed -r \
		-e "s#^(LUA_INC).*#\1=$($(tc-getPKG_CONFIG) --variable includedir ${lua})#" \
		-e "s#^(LUA_LIBDIR).*#\1=$($(tc-getPKG_CONFIG) --variable INSTALL_CMOD ${lua})#" \
		-e "s#^(CC).*#\1=$(tc-getCC)#" \
		-i config
}