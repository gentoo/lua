# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

# building fine, but not needed for Lua5.2 and Lua5.3
LUA_COMPAT="lua51 luajit2"

IS_MULTILIB=true
VCS="git-r3"

inherit lua

DESCRIPTION="A Lua5.2+ bit manipulation library"
HOMEPAGE="https://github.com/keplerproject/lua-compat-5.2"

EGIT_REPO_URI="https://github.com/keplerproject/lua-compat-5.2"
KEYWORDS=""
READMES=( README.md )

LICENSE="MIT"
SLOT="0"
IUSE=""

each_lua_compile() {
	_lua_setFLAGS
	local MY_PN="lbitlib"

	${CC} ${CFLAGS} -Ic-api -c -o ${MY_PN}.o ${MY_PN}.c || die
	${CC} ${LDFLAGS} -o ${PN}.so ${MY_PN}.o || die
}

each_lua_install() {
	dolua "${PN}.so"
}
