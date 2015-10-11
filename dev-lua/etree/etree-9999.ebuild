# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

VCS="git-r3"
inherit lua

DESCRIPTION="XML library that enables manipulation of XML documents as simple Lua data structures"
HOMEPAGE="https://github.com/msva/etree"
SRC_URI=""
EGIT_REPO_URI="https://github.com/msva/${PN}"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc"

RDEPEND="
	dev-lua/luaexpat
"
DEPEND="
	${RDEPEND}
"

READMES=( README doc/manual.txt )
HTML_DOCS=( doc/manual.html doc/style.css )

all_lua_compile() {
	touch .lua_eclass_config
	use doc && (
		emake doc
	)
}

src_compile() { :; }

each_lua_install() {
	dolua src/${PN}.lua
}
