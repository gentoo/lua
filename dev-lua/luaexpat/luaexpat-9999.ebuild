# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit multilib toolchain-funcs mercurial eutils

DESCRIPTION="XMPP client library written in Lua."
HOMEPAGE="http://code.matthewwild.co.uk/"
EHG_REPO_URI="http://code.matthewwild.co.uk/lua-expat/"
#EHG_REPO_URI="https://bitbucket.org/mva/luaexpat-temp"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="luajit"

RDEPEND="
	|| ( >=dev-lang/lua-5.1 dev-lang/luajit:2 )
	dev-libs/expat
"
DEPEND="
	${RDEPEND}
	dev-util/pkgconfig
"

src_compile() {
	local lua=lua;
	use luajit && lua=luajit
	emake \
		CC="$(tc-getCC)" \
		LDFLAGS="${LDFLAGS}" \
		CFLAGS="${CFLAGS}"  \
		LUA_INC="$($(tc-getPKG_CONFIG) --cflags ${lua})" || die "Compiling failed"}
}

src_install() {
	local lua=lua;
	use luajit && lua=luajit
	emake \
		LUA_LMOD="$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD ${lua})" \
		LUA_CMOD="$($(tc-getPKG_CONFIG) --variable INSTALL_CMOD ${lua})" \
		DESTDIR="${D}" \
		install || die "Install failed"
	dodoc README || die
	docompress -x "/usr/share/doc/${PF}/html"
	dohtml -r doc/* || die
}
