# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

VCS="git-r3"
inherit cmake-utils lua

DESCRIPTION="Lua bindings to libzip"
HOMEPAGE="https://github.com/brimworks/lua-zip"
EGIT_REPO_URI="https://github.com/brimworks/lua-zip.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	dev-libs/libzip
"

DEPEND="
	${RDEPEND}
"

READMES=( README )

each_lua_configure() {
	mycmakeargs=(
		-DINSTALL_CMOD="$(lua_get_pkgvar INSTALL_CMOD)"
	)
	cmake-utils_src_configure
}
