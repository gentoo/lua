# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

VCS="git-r3"
inherit lua

DESCRIPTION="Simple wrapper around luasoket smtp.send"
HOMEPAGE="https://github.com/moteus/lua-sendmail"
SRC_URI=""

EGIT_REPO_URI="https://github.com/moteus/lua-sendmail"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc"

RDEPEND="
	dev-lua/luasocket
"
DEPEND="
	${RDEPEND}
"

READMES=( README.md )
HTML_DOCS=( docs/ )

each_lua_install() {
	dolua lua/sendmail.lua
}
