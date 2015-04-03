# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit autotools eutils git-r3

DESCRIPTION="Lua GeoIP Library"
HOMEPAGE="https://github.com/msva/lua-geoip"
SRC_URI=""

EGIT_REPO_URI="https://github.com/msva/lua-geoip git://github.com/msva/lua-geoip"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="luajit"

RDEPEND="|| ( >=dev-lang/lua-5.1 dev-lang/luajit:2 )"
DEPEND="${RDEPEND}
	dev-libs/geoip"

src_prepare() {
	LUA="lua"
	default
	epatch_user
	use luajit && export LUA_INCLUDE_DIR="/usr/$(get_libdir)/luajit-2.0"
	use luajit && export LUA="luajit"
}

#Temporarily(?) broken on city database checking
#src_test() {
#	${LUA} test/test.lua
#}

src_install() {
	dodoc README.md TODO || die "dodoc failed"
	default
}
