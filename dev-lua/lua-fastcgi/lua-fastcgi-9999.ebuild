# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit eutils git-2

DESCRIPTION="A FastCGI server for Lua, written in C"
HOMEPAGE="https://github.com/cramey/lua-fastcgi"
SRC_URI=""

EGIT_REPO_URI="git://github.com/cramey/lua-fastcgi.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc"

RDEPEND="
	|| ( >=dev-lang/lua-5.1 dev-lang/luajit:2 )
	dev-libs/fcgi
"
DEPEND="${RDEPEND}"

src_install() {
	if use doc; then
		dodoc README.md TODO || die "dodoc failed"
	fi
	default
}
