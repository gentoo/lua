# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit eutils vcs-snapshot

DESCRIPTION="a Lua Profiler"
HOMEPAGE="https://gist.github.com/perky/2838755"
SRC_URI="https://gist.github.com/perky/2838755/download -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="x86 amd64 ppc mips arm"
IUSE="luajit"

RDEPEND="
	|| ( virtual/lua dev-lang/luajit:2 =dev-lang/lua-5.1* )
	virtual/pkgconfig
"
DEPEND="${RDEPEND}"

src_install() {
	local lua=lua;
	use luajit && lua=luajit
	insinto "$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD ${lua})"
	doins ProFi.lua
}
