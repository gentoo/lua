# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit autotools eutils git-r3 toolchain-funcs

DESCRIPTION="Lua GeoIP Library"
HOMEPAGE="https://github.com/msva/lua-geoip"
SRC_URI=""

EGIT_REPO_URI="https://github.com/msva/lua-geoip git://github.com/msva/lua-geoip"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="luajit"

RDEPEND="virtual/lua[luajit=]"
DEPEND="
	${RDEPEND}
	dev-libs/geoip
"

src_prepare() {
	local lua="lua"
	use luajit && lua="luajit";
	default
	epatch_user
	export LUA_INCLUDE_DIR="$($(tc-getPKG_CONFIG) --variable includedir ${lua})"
	export LUA="${lua}"
}

#Temporarily(?) broken on city database checking
#src_test() {
#	${LUA} test/test.lua
#}

src_install() {
	default
	dodoc README.md TODO || die "dodoc failed"
}
