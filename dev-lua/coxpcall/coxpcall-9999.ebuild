# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

VCS="git-r3"
inherit lua

DESCRIPTION="Lua coxpcall Library"
HOMEPAGE="https://github.com/keplerproject/coxpcall"
SRC_URI=""

#s/msva/keplerproject/ when they apply pull-request
EGIT_REPO_URI="https://github.com/msva/coxpcall.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc"

HTML_DOCS=( doc/us/ )

each_lua_install() {
	dolua src/*
}
