# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

IS_MULTILIB=true

inherit lua

DESCRIPTION=""
HOMEPAGE="http://webserver2.tecgraf.puc-rio.br/~lhf/ftp/lua/index.html#srlua"
SRC_URI="http://webserver2.tecgraf.puc-rio.br/~lhf/ftp/lua/${PV}/${PN}.tar.gz -> ${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~amd64 ~arm ~hppa ~mips x86"
IUSE=""

DOCS=(README)

LUA_S="${PN}"

PATCHES=("${FILESDIR}/patches/${PV}")

all_lua_prepare() {
	sed -r \
		-e '2aCFLAGS+=-Wall -Wextra -O0 -ggdb' \
		-e '2aLDFLAGS=-fPIC' \
		-e '2aLIBS=$(LDFLAGS) $(LUA_LINK_LIB) -ldl' \
		-e '2,/^LIBS/d' \
		-i Makefile
	lua_default
}

each_lua_test() {
	emake test.lua
}

each_lua_install() {
	local m_abi="${CHOST%%-*}"
	local l_abi="$(lua_get_lua)"
	exeinto /usr/libexec/"${PN}"
	newexe "${PN}" "${PN}.${l_abi}.${m_abi}"
	#newexe glue "glue.${l_abi}.${m_abi}"
	multilib_is_native_abi && doexe glue
	dobin "${FILESDIR}"/glue
}
