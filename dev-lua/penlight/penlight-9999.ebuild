# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

VCS="git-r3"
inherit lua

DESCRIPTION="A set of pure Lua libraries focusing on input data handling, functional programming and OS path management."
HOMEPAGE="https://github.com/stevedonovan/Penlight"
SRC_URI=""

EGIT_REPO_URI="https://github.com/stevedonovan/Penlight git://github.com/stevedonovan/Penlight"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc +examples test luajit"

# TODO: Lua 5.2 handling

DEPEND="
	${RDEPEND}
	doc? ( dev-lua/ldoc )
"

HTML_DOCS=( html/. )
DOCS=( README.md CHANGES.md CONTRIBUTING.md )
EXAMPLES=( examples/. )

all_lua_compile() {
	use doc && (
		cd doc
		ldoc . -d ../html
	)
}

each_lua_test() {
	${LUA} run.lua tests
}

each_lua_install() {
	dolua lua/pl
}
