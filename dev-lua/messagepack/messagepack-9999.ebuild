# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5


inherit toolchain-funcs git-r3

DESCRIPTION="A pure Lua implementation of msgpack.org"
HOMEPAGE="https://fperrad.github.io/lua-MessagePack/"
EGIT_REPO_URI="https://github.com/fperrad/lua-MessagePack.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="luajit lua53"

RDEPEND="
	!luajit? (
		!lua53? (
			|| (
				=dev-lang/lua-5.1*
				=dev-lang/lua-5.2*
			)
		)
		lua53? ( =dev-lang/lua-5.3* )
	)
	luajit?  ( dev-lang/luajit:2 )
"
DEPEND="${RDEPEND}
		dev-util/pkgconfig"

src_install() {
	local lua=lua
	use luajit && lua=luajit

	insinto "$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD ${lua})"
	if use lua53; then
		doins src5.3/MessagePack.lua
	else
		doins src/MessagePack.lua
	fi
}

