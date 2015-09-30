# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

IS_MULTILIB=true
VCS="git-r3"
inherit lua

DESCRIPTION="inotify bindings for Lua"
HOMEPAGE="https://github.com/hoelzro/linotify"
SRC_URI=""

EGIT_REPO_URI="https://github.com/hoelzro/linotify.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="virtual/libc"

READMES=( README.md )

each_lua_compile() {
	lua_default LUAPKG_CMD="${lua_impl}"
}

each_lua_install() {
	dolua inotify.so
}
