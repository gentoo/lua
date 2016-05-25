# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

VCS="git-r3"
inherit lua

DESCRIPTION="A pure Lua implementation of msgpack.org"
HOMEPAGE="https://fperrad.github.io/lua-MessagePack/"
EGIT_REPO_URI="https://github.com/fperrad/lua-MessagePack.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

each_lua_install() {
	local insfrom;
	if [[ "${TARGET}" = "lua53" ]]; then
		insfrom=src5.3
	else
		insfrom=src
	fi

	dolua "${insfrom}"/MessagePack.lua
}

