# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit cmake-utils git-2

DESCRIPTION="Lua cURL Library"
HOMEPAGE="https://github.com/msva/lua-curl"
SRC_URI=""

EGIT_REPO_URI="git://github.com/msva/lua-curl.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc examples luajit"

RDEPEND="
	|| ( =dev-lang/lua-5.1* dev-lang/luajit:2 )
	luajit? ( dev-lang/luajit:2 )
	!luajit? ( =dev-lang/lua-5.1* )
"
DEPEND="${RDEPEND}
	net-misc/curl"

src_prepare() {
	epatch_user
	cmake-utils_src_prepare
}

src_compile() {
	cmake-utils_src_compile
}

src_configure() {
	mycmakeargs=(
		$(cmake-utils_use_use luajit)
	)
	cmake-utils_src_configure
}

src_install() {
	if use doc; then
		dodoc -r doc || die "dodoc failed"
	fi
	if use examples; then
		insinto /usr/share/doc/"${P}";
		doins -r examples
	fi
	cmake-utils_src_install
}
