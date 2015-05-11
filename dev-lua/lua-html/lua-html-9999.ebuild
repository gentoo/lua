# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI=5

inherit toolchain-funcs eutils git-r3 multilib-minimal

DESCRIPTION="lua bindings for HTMLParser in libxml2"
HOMEPAGE="https://github.com/sprhawk/lua-html"
SRC_URI=""

EGIT_REPO_URI="https://github.com/sprhawk/lua-html"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="luajit"

DEPEND="
	virtual/lua[luajit=]
	virtual/pkgconfig
"
RDEPEND="
	${DEPEND}
	dev-libs/libxml2
"

src_prepare() {
	local lua=lua
	use luajit && lua=luajit

	local libs="$($(tc-getPKG_CONFIG) --libs libxml-2.0) $($(tc-getPKG_CONFIG) --libs ${lua})"
	local cflags="$($(tc-getPKG_CONFIG) --cflags libxml-2.0) $($(tc-getPKG_CONFIG) --cflags ${lua})"

#		-e "s#^(LDFLAGS)=.*#\1=${LDFLAGS}#" \
	sed -r \
		-e "s#^(CFLAGS)=.*#\1=-c ${CFLAGS} ${cflags} -fPIC -DPIC#" \
		-e "s# -l.* (-o)# ${libs} \1#g" \
		-i Makefile

	sed -r \
		-e 's#libxml/HTMLParser.h#libxml/HTMLparser.h#' \
		-i html.c

	multilib_copy_sources
}

multilib_src_install() {
	local lua=lua;
	use luajit && lua=luajit;
	insinto "$($(tc-getPKG_CONFIG) --variable INSTALL_CMOD ${lua})"
	doins html.so
}

multilib_src_install_all() {
	dodoc Readme.md
}
