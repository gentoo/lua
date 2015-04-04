# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit multilib toolchain-funcs flag-o-matic mercurial eutils

DESCRIPTION="Lua to HTML code converter written in Lua."
HOMEPAGE="http://code.matthewwild.co.uk/"
EHG_REPO_URI="http://code.matthewwild.co.uk/${PN}/"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="luajit"

RDEPEND="
	virtual/lua[luajit=]
	dev-lua/squish
"
DEPEND="${RDEPEND}"

src_prepare() {
	local lua=lua
	use luajit && lua=luajit;
	sed -r \
		-e "1s|^(!#.*) lua|\1 ${lua}|" \
		-i lua2html.lua
}

src_compile() {
	squish
}

src_install() {
	dobin lua2html
	dodoc README
}
