# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit eutils toolchain-funcs git-r3

DESCRIPTION="A small lua module to generate CAPTCHA images using lua-gd"
HOMEPAGE="https://github.com/mrDoctorWho/lua-${PN}"
SRC_URI=""

EGIT_REPO_URI="https://github.com/mrDoctorWho/lua-${PN}"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="jpeg luajit png +samples"

RDEPEND="
	virtual/lua[luajit=]
	dev-lua/lua-gd[luajit=]
	media-libs/gd[jpeg=,truetype,png=]
"

REQUIRED_USE="|| ( jpeg png )"

DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

src_compile() { :; }

src_install() {
	local lua=lua;
	use luajit && lua=luajit;

	insinto "$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD ${lua})"
	doins -r src/*

	if use samples; then
		docompress -x /usr/share/doc/${PF}/examples
		dodoc -r examples
	fi
}
