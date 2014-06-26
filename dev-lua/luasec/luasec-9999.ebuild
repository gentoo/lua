# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit multilib toolchain-funcs eutils git-r3

DESCRIPTION="Lua binding for OpenSSL library to provide TLS/SSL communication."
HOMEPAGE="http://www.inf.puc-rio.br/~brunoos/luasec/"
#EGIT_REPO_URI="https://github.com/msva/luasec"
#EGIT_REPO_URI="https://github.com/mwild1/luasec"
EGIT_REPO_URI="https://github.com/brunoos/luasec"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="examples luajit"

RDEPEND="
	!luajit? ( >=dev-lang/lua-5.1[deprecated] )
	luajit? ( dev-lang/luajit:2 )
	dev-lua/luasocket
	dev-libs/openssl
"
DEPEND="
	${RDEPEND}
	dev-util/pkgconfig
"


src_prepare() {
	epatch "${FILESDIR}/fix_removed_destdir_support.patch" || die "Probably, Upstream finally returned DESTDIR instalation back. Please, report that."
}

src_compile() {
	local lua=lua;
	use luajit && lua=luajit;
	emake \
		CC="$(tc-getCC)" \
		LD="$(tc-getCC) -shared" \
		LUAPATH="$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD ${lua})" \
		LUACPATH="$($(tc-getPKG_CONFIG) --variable INSTALL_CMOD ${lua})" \
		INC_PATH="-I$($(tc-getPKG_CONFIG) --variable includedir ${lua})" \
		linux \
		|| die
}

src_install() {
	emake DESTDIR="${D}" install || die "Install failed"
	docompress -x /usr/share/doc/${PF}/samples
	use examples && dodoc -r samples
}
