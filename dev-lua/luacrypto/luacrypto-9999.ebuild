# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

LANGS=" en ru"

inherit eutils git-r3

DESCRIPTION="Lua Crypto Library"
HOMEPAGE="https://github.com/msva/lua-crypto"
SRC_URI=""

EGIT_REPO_URI="git://github.com/msva/lua-crypto.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc luajit"
IUSE+="${LANGS// / linguas_}"

RDEPEND="
	virtual/lua[luajit=]
	>=dev-libs/openssl-0.9.7
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	local lua=lua;
	use luajit && lua=luajit;
	sed \
		-e 's|LUA_IMPL := "lua"|LUA_IMPL := "'${lua}'"|' \
		-i Makefile
}

src_install() {
	if use doc; then
		dodoc README || die "dodoc (REAMDE) failed"
		for x in ${LANGS}; do
			if use linguas_${x}; then
				dohtml -r doc/${x} || die "dohtml failed"
			fi
		done
	fi
	default
}
