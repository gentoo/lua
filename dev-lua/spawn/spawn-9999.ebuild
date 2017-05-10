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

DEPEND="
	dev-lua/lunix
"
RDEPEND="
	${RDEPEND}
"

PATCHES=("${FILESDIR}/patches/${PV}")

all_lua_prepare() {
	mv "${PN}/posix.c" "${S}"
	lua_default
}

each_lua_compile() {
	_lua_setFLAGS
	${CC} ${CFLAGS} ${LDFLAGS} -I./vendor/compat-5.3/c-api/ -I$(lua_get_incdir) posix.c -o ${PN}.so
}

each_lua_install() {
	dolua "${PN}"
	dolua "${PN}.so"
}

