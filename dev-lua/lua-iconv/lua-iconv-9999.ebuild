# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

VCS="git-r3"
IS_MULTILIB=true
inherit lua

DESCRIPTION="Lua bindings for POSIX iconv"
HOMEPAGE="http://ittner.github.com/lua-iconv"
SRC_URI=""

EGIT_REPO_URI="https://github.com/ittner/lua-iconv"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

each_lua_install() {
	dolua iconv.so
}
