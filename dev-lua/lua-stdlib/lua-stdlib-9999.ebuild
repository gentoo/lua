# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

VCS="git-r3"

inherit lua

DESCRIPTION="Standard Lua libraries"
HOMEPAGE="https://github.com/lua-stdlib/lua-stdlib"
SRC_URI=""

EGIT_REPO_URI="https://github.com/lua-stdlib/lua-stdlib"

LICENSE="GPL"
SLOT="0"
KEYWORDS=""
IUSE=""

READMES=( README.md NEWS.md HACKING )

all_lua_prepare() {
	if [[ -n ${EVCS_OFFLINE} ]]; then
		die "Unfortunately, upstream uses buildsystem which depends on external submodules, so you won't be able to build package in offline mode. Sorry."
	fi

	./bootstrap --skip-rock-checks
}

each_lua_compile() {
	./config.status --file=lib/std.lua
}

each_lua_install() {
	dolua lib/std lib/std.lua
}
