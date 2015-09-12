# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

VCS="mercurial"
inherit lua

DESCRIPTION="Lua to HTML code converter written in Lua."
HOMEPAGE="http://code.matthewwild.co.uk/"
EHG_REPO_URI="http://code.matthewwild.co.uk/${PN}/"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	dev-lua/squish
"
DEPEND="${RDEPEND}"

DOCS=( README )

all_lua_compile() {
	squish
}

all_lua_install() {
	dobin lua2html
}
