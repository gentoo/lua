# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit base git-r3 toolchain-funcs eutils

DESCRIPTION="a testing tool for Lua, providing a Behaviour Driven Development framework in the vein of RSpec"
HOMEPAGE="https://github.com/gvvaughan/specl"
SRC_URI=""

EGIT_REPO_URI="https://github.com/gvvaughan/specl"

LICENSE="GPL"
SLOT="0"
KEYWORDS=""
IUSE="luajit"

RDEPEND="
	virtual/lua[luajit=]
	dev-lua/luamacro
	dev-lua/lyaml
"
DEPEND="${RDEPEND}"

DOCS=( "README.md" "NEWS" )

src_prepare() {
	if [[ -n ${EVCS_OFFLINE} ]]; then
		die "Unfortunately, upstream uses buildsystem which depends on external submodules, so you won't be able to build package in offline mode. Sorry."
	fi

	local lua=lua;
	use luajit && lua=luajit;
	export LUA="${lua}"

	./bootstrap --skip-rock-checks
}

src_configure() {
	myeconfargs=(
		"--datadir=$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD ${LUA})" \
		"--libdir=$($(tc-getPKG_CONFIG) --variable INSTALL_CMOD ${LUA})" \
		"LUA_INCLUDE=-I$($(tc-getPKG_CONFIG) --variable includedir ${LUA})"
	)
	base_src_configure "${myeconfargs[@]}"
}

src_compile() {
	cd "${S}";
	./config.status --file=lib/specl/version.lua
}

src_install() {
	rm lib/specl/version.lua.in
	insinto $($(tc-getPKG_CONFIG) --variable INSTALL_LMOD ${LUA})
	doins -r lib/specl
}
