# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit eutils games

DESCRIPTION="A mix from Nintendo's Super Mario Bros and Valve's Portal"
HOMEPAGE="http://stabyourself.net/${PN}/"
SRC_URI="http://stabyourself.net/dl.php?file=${PN}-1006/${PN}-source.zip -> ${P}.zip"
LICENSE="CCPL-Attribution-ShareAlike-NonCommercial-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT=""

RDEPEND=">=games-engines/love-0.8.0
         media-libs/devil[gif,png]"
DEPEND="app-arch/unzip"

S="${WORKDIR}"

src_unpack() {
	default
	mv "${P/-/_}.love" "${P}.zip"
	unpack "./${P}.zip"
	rm "${P}.zip"
}

src_prepare() {
	default
	epatch_user
}

src_install() {
        local dir="${GAMES_DATADIR}/love/${PN}"
	insinto "${dir}"
	doins -r .
        doins -s scalable "${FILESDIR}/${PN}.svg"
	games_make_wrapper "${PN}" "love /usr/share/games/love/${P}"
        make_desktop_entry "${PN}"
        prepgamesdirs
}

pkg_postinst() {
        elog "${PN} savegames and configurations are stored in:"
        elog "~/.local/share/love/${PN}/"
}
