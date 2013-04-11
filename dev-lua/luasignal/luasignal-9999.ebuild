# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit multilib eutils git-2

DESCRIPTION="Lua signal Library"
HOMEPAGE="https://github.com/msva/lua-signal"
SRC_URI=""

EGIT_REPO_URI="git://github.com/msva/lua-signal.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="|| ( >=dev-lang/lua-5.1 dev-lang/luajit:2 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_configure() {
	sed -e "s#LUA_LIBDIR.*#LUA_LIBDIR=$($(tc-getPKG_CONFIG) lua --variable INSTALL_CMOD)#g" -i Make.config
}
