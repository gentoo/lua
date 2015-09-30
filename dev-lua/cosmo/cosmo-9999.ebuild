# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

VCS="git-r3"
inherit lua

DESCRIPTION="safe-template engine for lua"
HOMEPAGE="https://github.com/mascarenhas/cosmo"
SRC_URI=""

EGIT_REPO_URI="https://github.com/mascarenhas/cosmo.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc +examples"

RDEPEND="
	|| (
		dev-lua/lpeg
		dev-lua/lulpeg[lpeg_replace]
	)
"

DOCS=( README doc/cosmo.md )
HTML_DOCS=( doc/index.html doc/cosmo.png )
EXAMPLES=( samples/sample.lua )

each_lua_install() {
	dolua src/*
}

