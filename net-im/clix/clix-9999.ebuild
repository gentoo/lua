# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit mercurial eutils

DESCRIPTION="XMPP client library written in Lua."
HOMEPAGE="http://code.matthewwild.co.uk/"
EHG_REPO_URI="http://code.matthewwild.co.uk/${PN}/"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="luajit"

RDEPEND="
	|| ( =dev-lang/lua-5.1* dev-lang/luajit:2 )
	dev-lua/squish
	dev-lua/verse
	dev-lua/luaexpat
"
DEPEND="${RDEPEND}"

src_prepare() {
	use luajit && sed -r \
		-e 's:(env lua):\1jit:' \
		-i clix.lua
}

src_compile() {
	squish
}

src_install() {
	newbin clix.bin clix
	dodoc README
}
