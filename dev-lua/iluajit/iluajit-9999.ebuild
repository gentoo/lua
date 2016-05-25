# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI=6

LUA_COMPAT=luajit2
VCS=git
GITHUB_A=jdesgats
GITHUB_PN=ILuaJIT

inherit lua

DESCRIPTION="Readline powered shell for LuaJIT"

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
HTML_DOCS=( html/. )

all_lua_prepare() {
	use doc && luadoc . -d html
}

each_lua_install() {
	dolua_jit *.lua
}

all_lua_install() {
	dobin ${FILESDIR}/${PN}
}
