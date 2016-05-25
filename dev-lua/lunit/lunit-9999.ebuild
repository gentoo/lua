# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

VCS="git-r3"
inherit lua

DESCRIPTION="A unit testing framework for Lua"
HOMEPAGE="https://github.com/dcurrie/lunit"
SRC_URI=""

EGIT_REPO_URI="https://github.com/dcurrie/${PN}"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="+examples"

EXAMPLES=( examples/. )
READMES=( README README.lunitx DOCUMENTATION )

each_lua_install() {
	dolua lua/*
}

all_lua_install() {
	newbin "extra/${PN}.sh" "${PN}"
}
