# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="4"

inherit eutils git-2

DESCRIPTION="A set of Lua bindings for the Fast Artificial Neural Network (FANN) library."
HOMEPAGE="https://github.com/msva/lua-fann"
SRC_URI=""

EGIT_REPO_URI="https://github.com/msva/lua-fann git://github.com/msva/lua-fann"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="doc luajit"

RDEPEND="|| ( >=dev-lang/lua-5.1 dev-lang/luajit:2 )
	sci-mathematics/fann"
DEPEND="${RDEPEND}"

src_prepare() {
	LUABIN="lua"
	default
	epatch_user
	use luajit && export LUA_INCLUDE_DIR="/usr/$(get_libdir)/luajit-2.0"
	use luajit && export LUABIN="luajit"
}

src_test() {
	emake test
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
