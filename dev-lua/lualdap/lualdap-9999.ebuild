# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

VCS="git-r3"
IS_MULTILIB=true
inherit lua

DESCRIPTION="Lua driver for LDAP"
HOMEPAGE="https://github.com/mwild1/lualdap/"
SRC_URI=""

EGIT_REPO_URI="https://github.com/mwild1/lualdap.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc +examples"

RDEPEND="
	net-nds/openldap
"
DEPEND="${RDEPEND}"

READMES=( README )
EXAMPLES=( tests/ )
HTML_DOCS=( doc/us/ )

all_lua_prepare() {
	sed -i -e 'd' config
	lua_default
}

each_lua_configure() {
	local luav="$(lua_get_abi)"
	luav="${luav//./0}"
	myeconfargs=()
	myeconfargs+=(
		OPENLDAP_LIB="-lldap"
		LUA_VERSION_LUM="${luav}"
		LIBNAME="${PN}.so"
		LIB_OPTION='$(LDFLAGS)'
	)
	lua_default
}

#each_lua_test() {
#	Requires LDAP server
#	${LUA} tests/test.lua <hostname>[:port] <base> [<who> [<password>]]
#}

each_lua_install() {
	dolua src/${PN}.so
}
