# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

VCS="git-r3"
inherit lua

DESCRIPTION="A LuaDoc-compatible documentation generation system"
HOMEPAGE="https://github.com/stevedonovan/LDoc/"
SRC_URI=""

EGIT_REPO_URI="https://github.com/stevedonovan/LDoc/"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc"

RDEPEND="
	dev-lua/penlight
"

DOCS=( doc/doc.md readme.md )

HTML_DOCS=( doc_html/ ldoc_html/ )

all_lua_prepare() {
	local lua="$(lua_get_implementation)"

	cd doc; ${lua} ../ldoc.lua . -d ../doc_html; cd ..
	cd ldoc; ${lua} ../ldoc.lua . -d ../ldoc_html; cd ..

	rm ldoc/{SciTE.properties,config.ld}
}

each_lua_install() {
	dolua ldoc ldoc.lua
}

all_lua_install() {
	newbin ldoc.lua ldoc
}
