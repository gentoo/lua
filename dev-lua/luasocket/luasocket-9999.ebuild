# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit multilib toolchain-funcs flag-o-matic eutils git-2

DESCRIPTION="Networking support library for the Lua language."
HOMEPAGE="http://www.tecgraf.puc-rio.br/~diego/professional/luasocket/"
#EHG_REPO_URI="http://code.matthewwild.co.uk/luasocket2-hg/"
EGIT_REPO_URI="https://github.com/diegonehab/luasocket git://github.com/diegonehab/luasocket"
EGIT_BRANCH="unstable"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="debug luajit"

RDEPEND="|| ( >=dev-lang/lua-5.1 dev-lang/luajit:2 )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

src_compile() {
	local inc=/usr/include
	use luajit && inc=/usr/include/luajit-2.0

	use debug && export DEBUG="DEBUG"

	emake linux \
		prefix=/usr \
		LUAINC_linux="${inc}" \
		LUALIB_linux=/usr/lib \
		CC="$(tc-getCC)" \
		LD="$(tc-getCC) -shared" \
		|| die
}

src_install() {
	local lua=lua;
	use luajit && lua=luajit;
	emake install \
		INSTALL_TOP_SHARE="${D}/$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD ${lua})" \
		INSTALL_TOP_LIB="${D}/$($(tc-getPKG_CONFIG) --variable INSTALL_CMOD ${lua} | sed -e "s:lib/:$(get_libdir)/:")" || die

	dodoc NEW README || die
	dohtml doc/* || die
}
