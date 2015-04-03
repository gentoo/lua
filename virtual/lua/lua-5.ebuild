# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

DESCRIPTION="Virtual for Lua programming language"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE="lua luajit"

RDEPEND="
	|| ( >=dev-lang/lua-5 dev-lang/luajit:2 )
	luajit? ( dev-lang/luajit:2 app-eselect/luajit )
	app-eselect/lua
"
DEPEND="${RDEPEND}"
