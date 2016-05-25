# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

# fixme when fann will be multilib
#IS_MULTILIB=true
inherit lua

DESCRIPTION="A set of Lua bindings for the Fast Artificial Neural Network (FANN) library."
HOMEPAGE="https://github.com/msva/lua-fann"
SRC_URI="https://github.com/msva/${PN}/archive/${PV}.tar.gz -> ${P}.tgz"

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
EXAMPLES=( examples/ )

all_lua_compile() {
	use doc && (
		emake docs
	)
}

each_lua_compile() {
	lua_default \
		LUA_IMPL="$(lua_get_lua)" \
		LUA_BIN="${LUA}" \
		LUA_INC="."
}

each_lua_test() {
	emake test
}

each_lua_install() {
	dolua fann.so
}
