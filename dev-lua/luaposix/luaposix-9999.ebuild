# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit base git-r3 toolchain-funcs eutils

DESCRIPTION="POSIX binding, including curses, for Lua 5.1 and 5.2"
HOMEPAGE="https://github.com/luaposix/luaposix"
SRC_URI=""

EGIT_REPO_URI="https://github.com/luaposix/luaposix.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="luajit ncurses"

RDEPEND="
	!luajit? ( >=dev-lang/lua-5.1 )
	luajit? ( dev-lang/luajit:2 )
"
DEPEND="${RDEPEND}"

DOCS=( "README.md" "NEWS" )

src_prepare() {
	if [[ -n ${EVCS_OFFLINE} ]]; then
		die "Unfortunately, upstream uses buildsystem which depends on external submodules, so you won't be able to build package in offline mode. Sorry."
	fi

	./bootstrap
}

src_configure() {
	local lua=lua;
	use luajit && lua=luajit;
	myeconfargs=(
		"--datadir=$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD ${lua})" \
		"--libdir=$($(tc-getPKG_CONFIG) --variable INSTALL_CMOD ${lua})" \
		"$(use_with ncurses)"
		"LUA=${lua}" \
		"LUA_INCLUDE=-I$($(tc-getPKG_CONFIG) --variable includedir ${lua})"
	)
	base_src_configure "${myeconfargs[@]}"
}