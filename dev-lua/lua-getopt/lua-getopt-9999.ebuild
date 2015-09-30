# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

VCS="git-r3"
inherit lua

DESCRIPTION="Lua getopt module (simplified)"
HOMEPAGE="https://github.com/jjensen/lua-getopt"
EGIT_REPO_URI="https://github.com/jjensen/lua-getopt"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

each_lua_install() {
	dolua src/getopt.lua
}
