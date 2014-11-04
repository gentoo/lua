# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit cmake-utils git-r3

DESCRIPTION="Lua JSON Library, written in C"
HOMEPAGE="http://www.kyne.com.au/~mark/software/lua-cjson.php"
SRC_URI=""

EGIT_REPO_URI="https://github.com/msva/lua-cjson"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="examples luajit"

RDEPEND="
	luajit? ( dev-lang/luajit:2 )
	!luajit? ( >=dev-lang/lua-5.1 )
"
DEPEND="${RDEPEND}"

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_use luajit)
	)
	cmake-utils_src_configure
}

src_install() {
	if use examples; then
		insinto /usr/share/doc/"${P}"
		doins -r tests
	fi
	cmake-utils_src_install
}
