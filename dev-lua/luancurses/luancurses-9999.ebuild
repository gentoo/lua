# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit eutils git-2

DESCRIPTION="Lua NCurses Library"
HOMEPAGE="https://github.com/msva/lua-ncurses"
SRC_URI=""

EGIT_REPO_URI="git://github.com/msva/lua-ncurses.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="luajit"

RDEPEND="|| ( >=dev-lang/lua-5.1 dev-lang/luajit:2 )
	sys-libs/ncurses"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_prepare() {
	local lua=lua;
	use luajit && lua=luajit;
	echo LUA_IMPL="${lua}" > .config
}