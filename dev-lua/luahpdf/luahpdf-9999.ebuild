# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

VCS="git-r3"
IS_MULTILIB=true
inherit lua

DESCRIPTION="Lua binding to media-libs/libharu (PDF generator)"
HOMEPAGE="https://github.com/jung-kurt/luahpdf"
SRC_URI=""

EGIT_REPO_URI="https://github.com/msva/luahpdf"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc +examples"

RDEPEND="
	media-libs/libharu
"
DEPEND="${RDEPEND}"

DOCS=( README.md doc/text/. )
HTML_DOCS=( doc/html/. )
EXAMPLES=( demo/. )

all_lua_prepare() {
	sed -i -r \
	-e 's#(_COMPILE=)cc#\1$(CC)#' \
	-e 's#(_LINK=)cc#\1$(CC)#' \
	-e 's#(_REPORT=).*#\1#' \
	Makefile

	lua_default
}

each_lua_install() {
	dolua hpdf.so
}
