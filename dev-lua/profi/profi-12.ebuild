# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit lua

DESCRIPTION="a Lua Profiler"
HOMEPAGE="https://gist.github.com/perky/2838755"
SRC_URI="https://gist.github.com/perky/2838755/archive/78e573ca38b859c8639427c52d2c850736969bc7.tar.gz -> ${P}.tar.gz"
#SRC_URI="https://gist.github.com/perky/2838755/download -> ${P}.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="x86 amd64 ppc mips arm"
IUSE=""

LUA_S="2838755-78e573ca38b859c8639427c52d2c850736969bc7"

each_lua_install() {
	dolua ProFi.lua
}
