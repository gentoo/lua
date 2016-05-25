# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

VCS="git-r3"
inherit lua

DESCRIPTION="A small Lua interface to Sentry"
HOMEPAGE="https://github.com/cloudflare/raven-lua"
SRC_URI=""

EGIT_REPO_URI="https://github.com/cloudflare/${PN}-lua"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc +examples"

RDEPEND="
	dev-lua/lua-cjson
	dev-lua/lunit
	dev-lua/luaposix
"
DEPEND="
	${RDEPEND}
"

READMES=( README.md )
HTML_DOCS=( docs/. )
EXAMPLES=( tests/. )

# Makefile is only used to run tests
src_compile() { :; }

each_lua_install() {
	dolua raven.lua
}
