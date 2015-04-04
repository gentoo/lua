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

RDEPEND="virtual/lua[luajit=]"
DEPEND="${RDEPEND}"

src_prepare() {
	use luajit && sed -r \
		-e '1s:(env lua):\1jit:' \
		-i squish.lua make_squishy
}

src_install() {
	dobin squish || die;
	dobin make_squishy || die;
	dodoc README CHANGES || die
}
