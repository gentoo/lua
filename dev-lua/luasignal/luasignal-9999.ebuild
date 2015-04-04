# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit multilib eutils git-r3

DESCRIPTION="Lua signal Library"
HOMEPAGE="https://github.com/msva/lua-signal"
SRC_URI=""

EGIT_REPO_URI="https://github.com/msva/lua-signal.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="luajit"

RDEPEND="virtual/lua[luajit=]"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

src_configure() {
	local lua=lua;
	use luajit && lua=luajit;
	echo "LUA_IMPL=${lua}" > .config
}
