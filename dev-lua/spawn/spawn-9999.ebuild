# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS="git"
GITHUB_A="daurnimator"
GITHUB_PN="lua-${PN}"
IS_MULTILIB=true

inherit lua

DESCRIPTION="A lua library to spawn programs"
HOMEPAGE="https://github.com/daurnimator/lua-spawn"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="examples"

EXAMPLES=(spec/.)

all_lua_prepare() {
	mv "${PN}/init.lua" "${PN}.lua"
	lua_default
}

each_lua_compile() {
	_lua_setFLAGS
	${CC} ${CFLAGS} ${LDFLAGS} -I./vendor/compat-5.3/c-api/ -I$(lua_get_incdir) ${PN}/kill.c ${PN}/posix.c ${PN}/sigset.c ${PN}/wait.c -o ${PN}.so
}

each_lua_install() {
	dolua "${PN}.lua"
	dolua "${PN}.so"
}

