# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

VCS=git-r3
inherit lua

DESCRIPTION="A simple Lua function for printing to the console in color."
HOMEPAGE="https://github.com/kikito/ansicolors.lua"
SRC_URI=""

EGIT_REPO_URI="https://github.com/kikito/ansicolors.lua"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

READMES=( "README.textile" )

each_lua_install() {
	dolua ansicolors.lua
}
