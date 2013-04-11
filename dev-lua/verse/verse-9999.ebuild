# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit mercurial eutils

DESCRIPTION="XMPP client library written in Lua."
HOMEPAGE="http://code.mathewwild.co.uk/"
EHG_REPO_URI="http://code.matthewwild.co.uk/${PN}/"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc luajit"

RDEPEND="
	|| ( =dev-lang/lua-5.1* dev-lang/luajit:2 )
	dev-lua/squish
	dev-lua/luasocket
	dev-lua/luaexpat
	dev-lua/luafilesystem
	dev-lua/LuaBitOp
"
DEPEND="${RDEPEND}"

src_compile() {
	squish --use-http
}

src_install() {
	local lua="lua";
	use luajit && lua="luajit"
	insinto "$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD ${lua})"
	doins verse.lua || die
	use doc && dodoc doc/* || die
}
