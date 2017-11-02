# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

GITHUB_A="tarruda"
GITHUB_PN="libmpack"

inherit lua

DESCRIPTION="Lua bindings for libmpack"
HOMEPAGE="https://github.com/tarruda/libmpack/"

#S="${WORKDIR}/all/libmpack-${PV}/binding/lua"
LUA_S="libmpack-${PV}/binding/lua"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm ~arm64"
IUSE="luajit test"

RDEPEND="
	|| (
		virtual/lua[luajit=]
		!luajit? (
			|| (
				( virtual/lua dev-lang/lua:5.1 )
				>=dev-lang/lua-5.1:0
			)
		)
		luajit? (
			|| (
				virtual/lua[luajit]
				>=dev-lang/luajit-2
			)
		)
	)
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
	test? ( dev-lua/busted )
"

each_lua_prepare() {
	sed \
		-e '/^LUA_/d' \
		-i Makefile
	if lua_is_jit; then
		sed \
			-e '1i#define luaL_reg luaL_Reg' \
			-i "${S}/lmpack.c"
	fi
}

each_lua_compile() {
	local myemakeargs=(
		USE_SYSTEM_LUA=yes
#		LUA_INCLUDE="$(lua_get_incdir)"
#		LUA_LIB=""
		# ^ lua modules shouldn't ever link against liblua
	)
	lua_default
}

each_lua_test() {
	${LUA} ${EROOT}/usr/bin/busted -o gtest test.lua || die
}

each_lua_install() {
	dolua "${PN}.so"
}
