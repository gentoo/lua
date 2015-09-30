# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI=5

VCS="git-r3"
inherit lua

DESCRIPTION="Some useful extensions to Lua classes"
HOMEPAGE="https://github.com/thenumbernine/lua-ext"
SRC_URI=""

EGIT_REPO_URI="https://github.com/thenumbernine/ext"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

READMES=( README )

each_lua_install() {
	_dolua_insdir="ext" \
	dolua *.lua
}
