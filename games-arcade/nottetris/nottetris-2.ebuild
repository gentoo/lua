# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="3"

inherit eutils games

DESCRIPTION="A tetris game with physics"
HOMEPAGE="http://stabyourself.net/${PN}2/"
SRC_URI="http://stabyourself.net/dl.php?file=${PN}2/${PN}2-source.zip -> ${P}.zip"
LICENSE="GPL-2"
SLOT="0"

# Currently not usable with love-0.8.0.
# Waiting for fixes from upstream.
KEYWORDS="-*"

IUSE=""
RESTRICT=""

DEPEND=">=games-engines/love-0.8.0"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_unpack() {
	default
	#it is only one .love file, so we can use asterisk
	mv *.love "${P}.zip"
	unpack "./${P}.zip"
	rm "${P}.zip"
}

src_prepare() {
	default
	epatch_user
}

src_install() {
	insinto "/usr/share/games/love/${P}"
	doins -r .
	games_make_wrapper "${PN}" "love /usr/share/games/love/${P}"
}
