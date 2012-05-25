# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="3"

inherit eutils games

DESCRIPTION="A physics based game done in 19 hours during the Devmania 2011 Overnight Contest."
HOMEPAGE="http://gamejams.schattenkind.net/2011/10/pirate-bay.html"
SRC_URI="http://ghoulsblade.schattenkind.net/files/piratebay.love -> ${P}.zip"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT=""

DEPEND=">=games-engines/love-0.8.0"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_install() {
	insinto "/usr/share/games/love/${P}"
	doins -r .
	games_make_wrapper "${PN}" "love /usr/share/games/love/${P}"
}
