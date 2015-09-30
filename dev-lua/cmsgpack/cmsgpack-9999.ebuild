# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

IS_MULTILIB=true
VCS="git-r3"

inherit lua

DESCRIPTION="A self contained Lua MessagePack C implementation"
HOMEPAGE="https://github.com/antirez/lua-cmsgpack"

EGIT_REPO_URI="https://github.com/antirez/lua-cmsgpack"
KEYWORDS=""
READMES=( README.md )

LICENSE="BSD-2"
SLOT="0"
IUSE="test"

each_lua_compile() {
	_lua_setCFLAGS
	local MY_PN="lua_${PN}"

	${CC} ${CFLAGS} -c -o ${MY_PN}.o ${MY_PN}.c || die
	${CC} ${LDFLAGS} -o ${PN}.so ${MY_PN}.o || die
}

each_lua_test() {
	${LUA} test.lua || die
}

each_lua_install() {
	dolua "${PN}.so"
}
