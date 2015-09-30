# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

VCS="git-r3"
inherit lua

DESCRIPTION="library and driver script for preprocessing and evaluating Lua code"
HOMEPAGE="https://github.com/stevedonovan/LuaMacro/"
SRC_URI=""

EGIT_REPO_URI="https://github.com/stevedonovan/LuaMacro/"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	|| (
		dev-lua/lpeg
		dev-lua/lulpeg[lpeg_replace]
	)
"

each_lua_install() {
	dolua macro{,.lua}
}

all_lua_install() {
	dobin luam
}
