# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit eutils toolchain-funcs git-r3

DESCRIPTION="A unit testing framework for Lua"
HOMEPAGE="https://github.com/dcurrie/${PN}"
SRC_URI=""

EGIT_REPO_URI="https://github.com/dcurrie/${PN}"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="luajit +examples"

RDEPEND="
	virtual/lua[luajit=]
"

DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
	local lua=lua;
	use luajit && lua=luajit;

	sed -r \
		-e "s/^(interpreter)=.*/\1=${lua}/" \
		-i extra/lunit.sh
}

src_compile() { :; }

src_install() {
	local lua=lua;
	use luajit && lua=luajit;

	insinto "$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD ${lua})"
	doins -r lua/*

	newbin "extra/${PN}.sh" "${PN}"

	if use samples; then
		docompress -x "/usr/share/doc/${PF}/examples"
		dodoc -r examples
	fi

	dodoc DOCUMENTATION
}
