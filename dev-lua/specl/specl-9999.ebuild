# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS="git"
GITHUB_A="gvvaughan"

inherit lua

EGIT_BRANCH="v14.1"

DESCRIPTION="a testing tool for Lua, providing a Behaviour Driven Development framework in the vein of RSpec"
HOMEPAGE="https://github.com/gvvaughan/specl"

LICENSE="GPL"
SLOT="0"
KEYWORDS=""
IUSE="doc"

lua_add_rdepend dev-lua/luamacro
lua_add_rdepend dev-lua/lyaml
lua_add_bdepend dev-lua/lyaml
lua_add_bdepend dev-lua/lua-std-normalize

DOCS=(README.md doc/specl.md NEWS.md)
HTML_DOCS=(doc/.)

each_lua_compile() {
	make lib/specl/version.lua
}

all_lua_compile() {
	lua_default
	emake doc/specl.1
}

each_lua_install() {
	dobin bin/specl
	dolua lib/specl
}
