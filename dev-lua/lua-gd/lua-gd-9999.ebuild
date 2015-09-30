# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

VCS="git-r3"
IS_MULTILIB=true
inherit lua

DESCRIPTION="Lua bindings to Thomas Boutell's gd library"
HOMEPAGE="http://lua-gd.luaforge.net/"
SRC_URI=""
EGIT_REPO_URI="https://github.com/ittner/lua-gd.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc +examples"

RDEPEND="
	media-libs/gd[png]
"
DEPEND="
	${RDEPEND}
"

READMES=( README )
EXAMPLES=( demos/* )
HTML_DOCS=( doc/ )

all_lua_prepare() {
	sed -r \
		-e 's#CFLAGS#CF#g' \
		-e 's#LFLAGS#LF#g' \
		-e 's/^(CF=.*)/\1 $(CFLAGS)/' \
		-e 's/^(LF=.*)/\1 $(LDFLAGS)/' \
		-e 's/`pkg-config/`$(PKG_CONFIG)/' \
		-i Makefile
}

each_lua_compile() {
	local lua=$(lua_get_lua)
	lua_default \
		LUAPKG="${lua}" \
		LUABIN="${lua}" \
			gd.so
}

each_lua_install() {
	dolua gd.so
}
