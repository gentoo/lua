# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit eutils git-r3

DESCRIPTION="A set of pure Lua libraries focusing on input data handling, functional programming and OS path management."
HOMEPAGE="https://github.com/stevedonovan/Penlight"
SRC_URI=""

EGIT_REPO_URI="https://github.com/stevedonovan/Penlight git://github.com/stevedonovan/Penlight"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc +examples test luajit"

# TODO: Lua 5.2 handling

RDEPEND="
	|| ( virtual/lua dev-lang/luajit:2 =dev-lang/lua-5.1* )
	doc? ( dev-lua/luadoc )
	virtual/pkgconfig
"
DEPEND="${RDEPEND}"

DOCS=( README.md CHANGES.md CONTRIBUTING.md )

src_test() {
	local lua=lua;
	use luajit && lua=luajit
	${lua} run.lua tests
}

src_install() {
	local lua=lua;
	use luajit && lua=luajit
	use examples && {
		docompress -x /usr/share/doc/${PF}/examples
		dodoc -r examples
	}
	use doc && (
		docompress -x /usr/share/doc/${PF}/html
		cd doc
		dodoc -r manual
# Still doesn't work
#		luadoc . -d html
#		dohtml -r html
	)
	insinto "$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD ${lua})"
	doins -r lua/pl
}
