# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

LUA_COMPAT="luajit2"
VCS="git-r3"

inherit lua

DESCRIPTION="Readline powered shell for LuaJIT"
HOMEPAGE="https://github.com/jdesgats/ILuaJIT"
SRC_URI=""

EGIT_REPO_URI="https://github.com/jdesgats/ILuaJIT.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc +completion"

RDEPEND="
	doc? ( dev-lua/luadoc )
	dev-lua/penlight
	sys-libs/readline
	completion? ( dev-lua/luafilesystem )
"
DEPEND="${RDEPEND}"

READMES=( README.md )
HTML_DOCS=( html/ )

all_lua_prepare() {
	use doc && luadoc . -d html
}

each_lua_install() {
	dolua *.lua
}

all_lua_install() {
#	make_wrapper "${PN}" "luajit -l ${PN}"
	dobin ${FILESDIR}/${PN}
}
