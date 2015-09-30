# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

VCS="git-r3"
inherit lua

DESCRIPTION="A pure Lua port of LPeg, Roberto Ierusalimschy's Parsing Expression Grammars library"
HOMEPAGE="https://github.com/pygy/LuLPeg"
SRC_URI=""

EGIT_REPO_URI="https://github.com/pygy/LuLPeg"

LICENSE="WTFPL"
SLOT="0"
KEYWORDS=""
IUSE="lpeg_replace"

READMES=( README.md TODO.md ABOUT )

each_lua_compile() {
	#paranoid mode:
	rm "${PN}.lua" && (
		cd src
		"${LUA}" ../scripts/pack.lua > ../"${PN}.lua"
	)
}

each_lua_install() {
	dolua "${PN}".lua
	use lpeg_replace && newlua "${PN}.lua" lpeg.lua
}
