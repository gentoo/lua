# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit base toolchain-funcs flag-o-matic eutils mercurial

DESCRIPTION="Lua feeds parsing library"
HOMEPAGE="http://code.matthewwild.co.uk/lua-feeds"
EHG_REPO_URI="http://code.matthewwild.co.uk/lua-feeds"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="luajit"

RDEPEND="
	|| ( dev-lang/lua dev-lang/luajit:2 )
"
DEPEND="
	${RDEPEND}
	dev-lua/squish
	dev-util/pkgconfig
"

DOCS=( "demo.lua" "demo_string.lua" )

src_install() {
	local lua=lua;
	use luajit && lua=luajit;
	cd "${S}"
	squish
	insinto "$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD ${lua})"
	newins "feeds.min.lua" "feeds.lua"
	base_src_install_docs
}