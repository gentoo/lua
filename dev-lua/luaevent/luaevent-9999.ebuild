# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

#LUA_COMPAT="lua51 lua52 luajit2"
VCS="git-r3"
IS_MULTILIB=true
inherit lua

DESCRIPTION="libevent bindings for Lua"
HOMEPAGE="http://luaforge.net/projects/luaevent http://repo.or.cz/w/luaevent.git"
EGIT_REPO_URI="https://github.com/harningt/luaevent"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	>=dev-libs/libevent-1.4
"
DEPEND="
	${RDEPEND}
"

READMES=( README )

PATCHES=( ${FILESDIR}/{gc-anchoring,lua5.3}.patch )

each_lua_install() {
	dolua lua/*
	_dolua_insdir="${PN}" \
	dolua core.so
}
