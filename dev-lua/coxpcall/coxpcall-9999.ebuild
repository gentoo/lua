# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit multilib eutils git-r3

DESCRIPTION="Lua coxpcall Library"
HOMEPAGE="https://github.com/keplerproject/coxpcall"
SRC_URI=""

#s/msva/keplerproject/ when they apply pull-request
EGIT_REPO_URI="git://github.com/msva/coxpcall.git https://github.com/msva/coxpcall.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc luajit"

RDEPEND="virtual/lua[luajit=]"
DEPEND="${RDEPEND}"

src_configure() {
	local lua="lua";
	use luajit && lua="luajit";
	./configure "${lua}"
}

src_install() {
	emake DESTDIR="${D}" install
	use doc && emake DESTDIR="${D}" DOC_PREFIX=/usr/share/doc/${PF}/ install-doc
}
