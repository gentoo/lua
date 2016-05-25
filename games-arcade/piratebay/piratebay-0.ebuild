# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils games

DESCRIPTION="A physics based game done in 19 hours during the Devmania 2011 Overnight Contest."
HOMEPAGE="http://gamejams.schattenkind.net/2011/10/pirate-bay.html"
SRC_URI="http://ghoulsblade.schattenkind.net/files/piratebay.love -> ${P}.zip"
LICENSE="ZLIB"
SLOT="0"
# Temporary broken. When I fix it — i'll unmask it
KEYWORDS="-*"
IUSE=""
RESTRICT=""

DEPEND=">=games-engines/love-0.8.0"
RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_install() {
        local dir="${GAMES_DATADIR}/love/${PN}"
        insinto "${dir}"
        doins -r .
        games_make_wrapper "${PN}" "love /usr/share/games/love/${P}"
        make_desktop_entry "${PN}"
        prepgamesdirs
}

pkg_postinst() {
        elog "${PN} savegames and configurations are stored in:"
        elog "~/.local/share/love/${PN}/"
}

