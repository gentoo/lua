# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit base multilib toolchain-funcs flag-o-matic eutils git-2

DESCRIPTION="Networking support library for the Lua language."
HOMEPAGE="http://www.tecgraf.puc-rio.br/~diego/professional/luasocket/"
EGIT_REPO_URI="https://github.com/diegonehab/luasocket git://github.com/diegonehab/luasocket"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="debug luajit"

RDEPEND="|| ( >=dev-lang/lua-5.1 dev-lang/luajit:2 )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

DOCS=( "NEW" "README" )
HTML_DOCS=( "doc/" )
src_compile() {
	local lua=lua;
	use luajit && lua=luajit;

	use debug && export DEBUG="DEBUG"

	emake linux \
		prefix="/usr" \
		LUAINC_linux="$($(tc-getPKG_CONFIG) --variable includedir ${lua})" \
		LUALIB_linux="/usr/$(get_libdir)" \
		CC="$(tc-getCC)" \
		LD="$(tc-getCC) -shared"
}

src_install() {
	local lua=lua;
	use luajit && lua=luajit;
	emake install \
		INSTALL_TOP_LDIR="${D}/$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD ${lua})" \
		INSTALL_TOP_CDIR="${D}/$($(tc-getPKG_CONFIG) --variable INSTALL_CMOD ${lua})"

	base_src_install_docs
}
