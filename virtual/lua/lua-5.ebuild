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
IUSE="lua luajit bit"

RDEPEND="
	!luajit? (
		|| (
			dev-lang/lua:5.1[deprecated]
			dev-lang/lua:5.2[deprecared]
			dev-lang/lua:5.3[deprecated]
		)
	)
	bit? (
		|| (
			dev-lang/lua:5.2[deprecated]
			dev-lang/lua:5.3[deprecated]
			dev-lang/luajit:2.0
			dev-lang/luajit:2.1
			dev-lua/LuaBitOp
		)
	)
	luajit? (
		|| (
			dev-lang/luajit:2.0
			dev-lang/luajit:2.1
		)
		app-eselect/eselect-luajit
	)
	app-eselect/eselect-lua
	!!dev-lang/lua:0
	!!dev-lang/luajit:2
"
DEPEND="${RDEPEND}"
