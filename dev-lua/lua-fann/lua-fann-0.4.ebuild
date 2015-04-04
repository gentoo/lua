# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit eutils toolchain-funcs

DESCRIPTION="A set of Lua bindings for the Fast Artificial Neural Network (FANN) library."
HOMEPAGE="https://github.com/msva/lua-fann"
SRC_URI="https://github.com/msva/{$PN}/archive/${PV}.tar.gz -> ${P}.tgz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="doc luajit"

RDEPEND="
	virtual/lua[luajit=]
	sci-mathematics/fann
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	local lua=lua;
	use luajit && lua=luajit;
	default
	epatch_user
	export LUA_INCLUDE_DIR="$($(tc-getPKG_CONFIG) --variable includedir ${lua})"
	export LUABIN="${lua}"
}

src_test() {
	emake test
}

src_install() {
	dodoc README.md TODO || die "dodoc failed"
	use doc && (
		emake docs
		dohtml doc/luafann.html
	)
	default
}
