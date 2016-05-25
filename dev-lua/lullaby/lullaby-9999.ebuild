# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

VCS="git-r3"
inherit lua

DESCRIPTION="A stream-based HTML template library for Lua."
HOMEPAGE="https://github.com/hugomg/lullaby"
SRC_URI=""

EGIT_REPO_URI="https://github.com/hugomg/lullaby"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc"

READMES=( README.md )
HTML_DOCS=( htmlspec/. )

each_lua_install() {
	dolua lullaby.lua lullaby
}
