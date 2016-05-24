# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

VCS="git-r3"
inherit lua

DESCRIPTION="A Lua implementation of Internationalizing Domain Names in Applications (RFC 3490)"
HOMEPAGE="https://github.com/haste/lua-idn"
SRC_URI=""

EGIT_REPO_URI="https://github.com/haste/lua-idn"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="test"

# TODO: Lua 5.2 handling

DEPEND="
	${RDEPEND}
"

each_lua_test() {
	${LUA} tests.lua
}

each_lua_install() {
	dolua idn.lua
}
