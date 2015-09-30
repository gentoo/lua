# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

LUA_COMPAT="lua51 luajit2"
VCS="mercurial"
IS_MULTILIB=true
inherit lua

DESCRIPTION="XMPP client library written in Lua."
HOMEPAGE="http://code.matthewwild.co.uk/"
EHG_REPO_URI="http://code.matthewwild.co.uk/lua-expat/"
#EHG_REPO_URI="https://bitbucket.org/mva/luaexpat-temp"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc"

RDEPEND="
	dev-libs/expat
"
DEPEND="
	${RDEPEND}
"

READMES=( README )
HTML_DOCS=( doc/ )

each_lua_install() {
	dolua src/lxp{,.so}
}
