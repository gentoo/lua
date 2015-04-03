# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit eutils git-r3

DESCRIPTION="Readline powered shell for LuaJIT"
HOMEPAGE="https://github.com/jdesgats/ILuaJIT"
SRC_URI=""

EGIT_REPO_URI="https://github.com/jdesgats/ILuaJIT git://github.com/jdesgats/ILuaJIT"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc +completion"

RDEPEND="
	doc? ( dev-lua/luadoc )
	dev-lang/luajit:2
	dev-lua/penlight
	sys-libs/readline
	completion? ( dev-lua/luafilesystem )
	virtual/pkgconfig
"
DEPEND="${RDEPEND}"

src_install() {
	local lmod="$($(tc-getPKG_CONFIG) --variable=INSTALL_LMOD luajit)"

	dodoc README.md || die "dodoc failed"
	use doc && (
		luadoc . -d html
		dohtml -r html
	)

	insinto "${lmod}"
	doins *.lua

	make_wrapper "${PN}" "luajit ${lmod}/${PN}.lua"
}
