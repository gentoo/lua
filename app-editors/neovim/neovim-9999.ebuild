# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit cmake-utils flag-o-matic git-r3

EGIT_REPO_URI="git://github.com/neovim/neovim.git"
KEYWORDS=""

DESCRIPTION="Vim's rebirth for the 21st century"
HOMEPAGE="https://github.com/neovim/neovim"

LICENSE="vim"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	app-admin/eselect-vi
	sys-libs/ncurses
"
DEPEND="
	${RDEPEND}
	|| (
		dev-lang/luajit
		dev-lang/lua
	)
	>=dev-libs/libuv-0.11.19
	|| (
		dev-lua/lpeg
		dev-lua/lulpeg[lpeg_replace]
	)
	dev-lua/messagepack
"

src_configure()  {
	append-flags "-DNDEBUG -Wno-error -D_FORTIFY_SOURCE=1"
	cmake-utils_src_configure
}


