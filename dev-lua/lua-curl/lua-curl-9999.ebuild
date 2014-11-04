# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit git-r3

DESCRIPTION="Lua cURL Library"
HOMEPAGE="https://github.com/Lua-cURL/Lua-cURLv3"
SRC_URI=""

EGIT_REPO_URI="https://github.com/Lua-cURL/Lua-cURLv3"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc examples luajit"

RDEPEND="
	luajit? ( dev-lang/luajit:2 )
	!luajit? ( >=dev-lang/lua-5.1 )
	net-misc/curl
"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
"

src_prepare() {
	epatch_user
}

src_configure() {
	local lua="lua";
	use luajit && lua="luajit";
	echo "LUA_IMPL=${lua}" > ${S}/.config;
}


src_install() {
	local lua=lua;
	use luajit && lua=luajit
	use examples && {
		docompress -x /usr/share/doc/${PF}/examples
		dodoc -r examples
	}
	use doc && (
		docompress -x /usr/share/doc/${PF}/html
		cd doc
		ldoc .
		dohtml -r html
	)
	default
}
