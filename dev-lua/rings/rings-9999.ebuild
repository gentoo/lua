# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit multilib toolchain-funcs flag-o-matic eutils git-r3

DESCRIPTION="Lua Rings Library"
HOMEPAGE="https://github.com/keplerproject/rings"
SRC_URI=""

#s/msva/keplerproject/ when they apply pull-request
EGIT_REPO_URI="git://github.com/msva/rings.git https://github.com/msva/rings.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="luajit"

RDEPEND="
	!luajit? ( >=dev-lang/lua-5.1 )
	luajit? ( dev-lang/luajit:2 )
"
DEPEND="${RDEPEND}"

src_configure() {
	local lua="lua";
	use luajit && lua="luajit"
	./configure "${lua}"
}

src_compile() {
	local lua="lua";
	use luajit && lua="luajit"
	append-cflags "-I$($(tc-getPKG_CONFIG) --variable includedir ${lua})"
	emake CC="$(tc-getCC) -fPIC -DPIC" LDFLAGS="${LDFLAGS}" CFLAGS="${CFLAGS}" || die "Can't copmile Rings library"
}
