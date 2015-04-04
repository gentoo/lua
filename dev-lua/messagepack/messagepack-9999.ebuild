# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"


inherit toolchain-funcs git-r3

DESCRIPTION="A pure Lua implementation of msgpack.org"
HOMEPAGE="https://fperrad.github.io/lua-MessagePack/"
EGIT_REPO_URI="https://github.com/fperrad/lua-MessagePack.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="luajit"

RDEPEND="
	virtual/lua[luajit=]
"
DEPEND="${RDEPEND}
		virtual/pkgconfig"

src_install() {
	local lua=lua
	use luajit && lua=luajit

	insinto "$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD ${lua})"
	if [[ "${lua}" = "lua" ]] && [[ $(${lua} -v 2>&1) =~ "5.3" ]]; then
		doins src5.3/MessagePack.lua
	else
		doins src/MessagePack.lua
	fi
}

