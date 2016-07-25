# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS="git"
GITHUB_A="brunoos"
IS_MULTILIB=true

inherit lua

DESCRIPTION="Lua binding for OpenSSL library to provide TLS/SSL communication."
HOMEPAGE="http://www.inf.puc-rio.br/~brunoos/luasec/"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="examples"

RDEPEND="
	dev-lua/luasocket
	dev-libs/openssl
"
DEPEND="
	${RDEPEND}
"

all_lua_prepare() {
	sed -i -r \
		-e 's#(MAKE\)).*(install)#\1 \2#' \
		Makefile
	epatch "${FILESDIR}/fix_removed_destdir_support.patch" || die "Probably, Upstream finally returned DESTDIR instalation back. Please, report that."
	cd src
	lua_default
}

each_lua_configure() {
	cd src
	myeconfargs=()
	myeconfargs+=(
		LD='$(CC)'
		LUAPATH="$(lua_get_pkgvar INSTALL_LMOD)"
		LUACPATH="$(lua_get_pkgvar INSTALL_CMOD)"
	)
		lua_default
}

each_lua_compile() {
	lua_default linux
}

#each_lua_install() {
#	dolua ssl.so ssl.lua
#	_dolua_insdir=ssl \
#	dolua https.lua
#}
