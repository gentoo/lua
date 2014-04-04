# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lua/toluapp/toluapp-1.0.93.ebuild,v 1.2 2012/11/18 23:28:11 rafaelmartins Exp $

EAPI="5"

inherit toolchain-funcs

MY_P=${P/pp/++}

DESCRIPTION="A tool to integrate C/C++ code with Lua."
HOMEPAGE="http://www.codenix.com/~tolua/"
SRC_URI="http://www.codenix.com/~tolua/${MY_P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="alpha amd64 ppc ppc64 sparc x86"
IUSE="luajit"

RDEPEND="|| ( =dev-lang/lua-5.1*[deprecated] dev-lang/luajit:2 )"
DEPEND="
	${RDEPEND}
	dev-util/scons
"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	local lua=lua;
	use luajit && lua=luajit-5.1;
	echo "LIBS = ['${lua}', 'dl', 'm']" > ${S}/custom.py
	sed -r \
		-e 's|(if rawtype.*arg.*)|\tlocal arg = {n=select('#', ...), ...};\n\1|' \
		-i src/bin/lua/compat.lua
}

src_compile() {
	scons \
		CC="$(tc-getCC)" \
		CCFLAGS="${CFLAGS} -ansi -Wall" \
		CXX="$(tc-getCXX)" \
		LINK="$(tc-getCC)" \
		LINKFLAGS="${LDFLAGS}" \
		shared=1 || die "scons failed"
}

src_install() {
	dobin bin/tolua++ || die "dobin failed"
#	dobin bin/tolua++_bootstrap || die "dobin failed"
#	dolib.a lib/libtolua++_static.a || die "dolib.a failed"
	dolib.so lib/libtolua++.so || die "dolib.so failed"
	insinto /usr/include
	doins include/tolua++.h || die "doins failed"
	dodoc README
	dohtml doc/*
}
