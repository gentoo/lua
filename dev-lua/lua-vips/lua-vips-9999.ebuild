# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS="git"
LUA_COMPAT="luajit2"
GITHUB_A="jcupitt"

inherit lua

DESCRIPTION="fast, low-memory-use image processing for luajit"
HOMEPAGE="https://github.com/jcupitt/lua-vips"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	media-libs/vips
"
DEPEND="
	${RDEPEND}
"

DOCS=(README.md)

each_lua_install() {
	dolua_jit src/*
}
