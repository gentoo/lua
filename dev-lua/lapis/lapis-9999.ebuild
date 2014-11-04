# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit base toolchain-funcs git-r3

DESCRIPTION="A web framework for Lua/MoonScript."
HOMEPAGE="https://github.com/leafo/lapis"
SRC_URI=""

EGIT_REPO_URI="https://github.com/leafo/lapis"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="luajit moonscript"

RDEPEND="
	!luajit? ( >=dev-lang/lua-5.1 )
	luajit?  ( dev-lang/luajit:2 )
	moonscript? ( dev-lua/moonscript )
	dev-lua/ansicolors
	dev-lua/luasocket
	dev-lua/luacrypto
	dev-lua/lua-cjson
	dev-lua/lpeg
	dev-lua/rds-parser
	dev-lua/resty-upload
"
DEPEND="
	${RDEPEND}
	dev-util/pkgconfig
"

HTML_DOCS=( "docs/" "README.md" )

src_compile() {
	use moonscript && emake build
}

src_install() {
	local lua=lua;
	use luajit && lua=luajit;

	use moonscript || find "${S}" -type -name '*.moon' -delete

	insinto "$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD ${lua})"
	doins -r lapis

	dobin bin/lapis

	use moonscript && doins lapis.moon

	base_src_install_docs
}
