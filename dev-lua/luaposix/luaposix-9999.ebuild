# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit base git-2 toolchain-funcs

DESCRIPTION="POSIX binding, including curses, for Lua 5.1 and 5.2"
HOMEPAGE="https://github.com/luaposix/luaposix"
SRC_URI=""

EGIT_REPO_URI="https://github.com/luaposix/luaposix.git git://github.com/luaposix/luaposix.git"
EGIT_BOOTSTRAP="./bootstrap"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="luajit ncurses"

RDEPEND="
	|| ( >=dev-lang/lua-5.1 dev-lang/luajit:2 )
"
DEPEND="${RDEPEND}"

DOCS=( "README.md" "NEWS" )

src_configure() {
	local lua=lua;
	use luajit && lua=luajit;

	econf \
		--datadir="$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD ${lua})" \
		--libdir="$($(tc-getPKG_CONFIG) --variable INSTALL_CMOD ${lua})" \
		$(use_with ncurses) \
		LUA="${lua}" \
		LUA_INCLUDE="-I$($(tc-getPKG_CONFIG) --variable includedir ${lua})"
}