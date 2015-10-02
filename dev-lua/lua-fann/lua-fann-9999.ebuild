# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

# fixme when fann will be multilib
#IS_MULTILIB=true
VCS="git-r3"
inherit lua

DESCRIPTION="A set of Lua bindings for the Fast Artificial Neural Network (FANN) library."
HOMEPAGE="https://github.com/msva/lua-fann"
SRC_URI=""
EGIT_REPO_URI="https://github.com/msva/${PN}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="doc +examples"

RDEPEND="
	sci-mathematics/fann
"
DEPEND="
	${RDEPEND}
"

READMES=( README.md TODO )
HTML_DOCS=( doc/luafann.html )
EXAMPLES=( test/. )

all_lua_compile() {
	touch .lua_eclass_config
	use doc && (
		emake docs
	)
}

each_lua_configure() {
	myeconfargs=(
		LUA_IMPL="$(lua_get_lua)"
		LUA_BIN="${LUA}"
	)
	lua_default
}

each_lua_test() {
	emake test
}

each_lua_install() {
	dolua fann.so
}
