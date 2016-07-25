# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

IS_MULTILIB=true
VCS="git"
GITHUB_A="msva"
inherit lua

DESCRIPTION="Allows Lua scripts to call external processes while capturing both their input and output."
HOMEPAGE="https://github.com/msva/lpc"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

each_lua_install() {
	dolua ${PN}.so
}
