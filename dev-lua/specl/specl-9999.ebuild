# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

VCS="git-r3"
inherit lua

DESCRIPTION="a testing tool for Lua, providing a Behaviour Driven Development framework in the vein of RSpec"
HOMEPAGE="https://github.com/gvvaughan/specl"
SRC_URI=""

EGIT_REPO_URI="https://github.com/gvvaughan/specl"

LICENSE="GPL"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	dev-lua/luamacro
	dev-lua/lyaml
"
DEPEND="${RDEPEND}"

READMES=( README.md NEWS )

all_lua_prepare() {
	if [[ -n ${EVCS_OFFLINE} ]]; then
		die "Unfortunately, upstream uses buildsystem which depends on external submodules, so you won't be able to build package in offline mode. Sorry."
	fi

	./bootstrap --skip-rock-checks
	lua_default
}

each_lua_configure() {
	myeconfargs=(
		"--datadir=$(lua_get_pkgvar INSTALL_LMOD)"
		"--libdir=$(lua_get_pkgvar INSTALL_CMOD)"
		"LUA_INCLUDE=-I$(lua_get_pkgvar includedir)"
	)
	lua_default
}

each_lua_compile() {
	./config.status --file=lib/specl/version.lua
}

each_lua_install() {
	rm lib/specl/version.lua.in
	dolua lib/specl
}
