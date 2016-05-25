# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

DESCRIPTION="An *awesome* framework you can use to make 2D games in Lua."
HOMEPAGE="http://love2d.org/"
if [[ ${PV} =~ "9999" ]]; then
	SCM_ECLASS="mercurial"
	EHG_REPO_URI="https://bitbucket.org/rude/love"
	SRC_URI=""
	KEYWORDS=""
else
	SRC_URI="https://bitbucket.org/rude/love/downloads/${P}-linux-src.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi;

inherit games eutils autotools ${SCM_ECLASS}

LICENSE="ZLIB"
SLOT="0"
IUSE=""

RDEPEND="
	dev-games/physfs
	media-libs/devil[mng,tiff]
	media-libs/freetype
	media-libs/libmodplug
	media-libs/libsdl[joystick,opengl]
	media-libs/libvorbis
	media-libs/openal
	media-sound/mpg123
	virtual/lua[luajit]
	virtual/opengl
"
DEPEND="
	${RDEPEND}
	media-libs/libmng
	media-libs/tiff
"

DOCS=( readme.md changes.txt )

src_prepare() {
	sh platform/unix/automagic || die
	eautoreconf
}

src_configure() {
	OPTS=()
	OPTS+=" --disable-dependency-tracking --disable-option-checking"
	econf ${OPTS}
}
