# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit toolchain-funcs git-r3

DESCRIPTION="A self contained Lua MessagePack C implementation"
HOMEPAGE="https://github.com/antirez/lua-cmsgpack"

MY_PN="lua_${PN}"

EGIT_REPO_URI="https://github.com/antirez/lua-cmsgpack"
KEYWORDS=""
DOCS=( README.md )

LICENSE="BSD-2"
SLOT="0"
IUSE="luajit test"

RDEPEND="
	luajit? ( dev-lang/luajit:2 )
	!luajit? ( >=dev-lang/lua-5.1 )
"
DEPEND="${RDEPEND}"

src_compile() {
	use luajit && CFLAGS="${CFLAGS} -I$($(tc-getPKG_CONFIG) --variable includedir luajit)"
	$(tc-getCC) -fPIC ${CFLAGS} -c -o ${MY_PN}.o ${MY_PN}.c || die
	$(tc-getCC) ${LDFLAGS} -shared -o ${PN}.so ${MY_PN}.o || die
}

src_test() {
	lua test.lua || die
}

src_install() {
	local lua=lua
	use luajit && lua=luajit
	default
	insinto "$($(tc-getPKG_CONFIG) --variable INSTALL_CMOD ${lua})"
	doins "${PN}".so
}
