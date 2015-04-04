# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit eutils git-r3

DESCRIPTION="Lua cURL Library"
HOMEPAGE="http://ittner.github.com/lua-iconv"
SRC_URI=""

EGIT_REPO_URI="https://github.com/ittner/lua-iconv.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="luajit"

RDEPEND="virtual/lua[luajit=]"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	epatch_user
	sed -e "s/install -D -s/install -D/" -i Makefile
	sed -e "/make test/d" -i Makefile
}

src_compile() {
	local lua=lua;
	use luajit && lua=luajit;
	emake LUAPKG="${lua}" || die "Can't compile"
}

src_install() {
	local lua=lua;
	use luajit && lua=luajit;
	emake DESTDIR="${D}" INSTALL_PATH="$($(tc-getPKG_CONFIG) --variable INSTALL_CMOD ${lua})" install || die "Can't install"
}
