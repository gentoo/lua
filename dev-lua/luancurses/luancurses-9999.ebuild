# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit eutils git-r3

DESCRIPTION="Lua NCurses Library"
HOMEPAGE="https://github.com/msva/lua-ncurses"
SRC_URI=""

EGIT_REPO_URI="git://github.com/msva/lua-ncurses.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="luajit"

RDEPEND="
	virtual/lua[luajit=]
	sys-libs/ncurses
"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

src_prepare() {
	local lua=lua;
	use luajit && lua=luajit;
	echo LUA_IMPL="${lua}" > .config
}
