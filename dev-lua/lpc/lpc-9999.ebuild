# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

IS_MULTILIB=true
VCS="git-r3"
inherit lua

DESCRIPTION="Allows Lua scripts to call external processes while capturing both their input and output."
HOMEPAGE="http://lua.net-core.org/sputnik.lua?p=Telesto:About"
EGIT_REPO_URI="https://github.com/msva/lpc"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

each_lua_install() {
	dolua ${PN}.so
}
