# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

VCS="git-r3"

# FIXME when GeoIP will be multilib
#IS_MULTILIB=true
inherit lua

DESCRIPTION="Lua GeoIP Library"
HOMEPAGE="https://agladysh.github.io/lua-geoip"
SRC_URI=""

EGIT_REPO_URI="https://github.com/msva/lua-geoip"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	dev-libs/geoip
"
DEPEND="
	${RDEPEND}
"

READMES=( README.md HISTORY TODO )

src_test() {
	${LUA} test/test.lua /usr/share/GeoIP/Geo{IP,LiteCity}.dat
}

each_lua_install() {
	dolua geoip{,.so}
}
