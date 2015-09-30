# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

VCS="git-r3"
inherit lua

DESCRIPTION="Lua cURL Library"
HOMEPAGE="https://github.com/Lua-cURL/Lua-cURLv3"
SRC_URI=""

EGIT_REPO_URI="https://github.com/Lua-cURL/Lua-cURLv3"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc +examples"

RDEPEND="
	net-misc/curl
"
DEPEND="
	doc? ( dev-lua/luadoc )
	${RDEPEND}
"

EXAMPLES=( examples/ )
HTML_DOCS=( html/ )
READMES=( README.md )

each_lua_compile() {
	lua_default LUA_IMPL="${lua_impl}"
}

all_lua_compile() {
	use doc && (
		cd doc
		ldoc . -d ../html
	)
}


each_lua_install() {
	lua_default LUA_IMPL="${lua_impl}"
}
