# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit eutils git-r3 toolchain-funcs

DESCRIPTION="A set of Lua bindings for the Fast Artificial Neural Network (FANN) library."
HOMEPAGE="https://github.com/msva/lua-fann"
SRC_URI=""

EGIT_REPO_URI="https://github.com/msva/lua-fann"

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
	echo "LUA_IMPL=${lua}" > .config
	default
}

src_install() {
	docompress -x /usr/share/doc/${PF}/examples
	dodoc README.md TODO || die "dodoc failed"
	use doc && (
		emake docs
		dohtml doc/luafann.html
		insinto /usr/share/doc/${PF}/examples
		doins -r test/*
	)
	default
}
