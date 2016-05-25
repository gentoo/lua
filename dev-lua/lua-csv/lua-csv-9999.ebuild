# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

VCS="git-r3"
inherit lua

DESCRIPTION="a Lua module for reading delimited text files"
HOMEPAGE="https://github.com/geoffleyland/lua-csv"
SRC_URI=""

EGIT_REPO_URI="https://github.com/geoffleyland/lua-csv"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

READMES=( README.md )

each_lua_install() {
	dolua lua/csv.lua
}
