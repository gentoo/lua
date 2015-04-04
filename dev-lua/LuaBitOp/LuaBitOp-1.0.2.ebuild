# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"
inherit eutils multilib toolchain-funcs

DESCRIPTION="Bit Operations Library for the Lua Programming Language"
HOMEPAGE="http://bitop.luajit.org"
SRC_URI="http://bitop.luajit.org/download/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="luajit"

DEPEND="virtual/lua[luajit=]"
RDEPEND="${DEPEND}"

src_prepare() {
	sed -i \
		-e '/^CFLAGS.*=/s/=/ +=/' \
		-e '/^CFLAGS/s/-O2 -fomit-frame-pointer //' \
		Makefile || die "sed failed"
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_test() {
	make test
}

src_install() {
	local lua=lua
	use luajit && lua=luajit
	exeinto "$($(tc-getPKG_CONFIG) --variable INSTALL_CMOD ${lua})"
	doexe bit.so
	dohtml -r doc/*
}
