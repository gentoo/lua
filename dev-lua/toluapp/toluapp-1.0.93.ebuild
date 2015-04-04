# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

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

RDEPEND="
	virtual/lua[luajit=]
"
DEPEND="
	${RDEPEND}
	dev-util/scons
"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	local lua=lua;
	use luajit && lua=$($(tc-getPKG_CONFIG) --variable libname luajit);
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
