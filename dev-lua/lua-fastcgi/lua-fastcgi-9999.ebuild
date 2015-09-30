# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

VCS="git-r3"
# FIXME when fcgi will be multilib
#IS_MULTILIB=true
inherit lua

DESCRIPTION="A FastCGI server for Lua, written in C"
HOMEPAGE="https://github.com/cramey/lua-fastcgi"
SRC_URI=""

EGIT_REPO_URI="https://github.com/cramey/lua-fastcgi.git"
EGIT_BRANCH="public"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc +examples"

RDEPEND="
	dev-libs/fcgi
"
DEPEND="${RDEPEND}"

READMES=( README.md TODO )
EXAMPLES=( ${PN}.lua )

all_lua_prepare() {
	sed -r \
		-e 's#CFLAGS#CF#g' \
		-e 's#LDFLAGS#LF#g' \
		-e 's#^(CF=)#\1 $(CFLAGS) #' \
		-e 's#^(LF=)#\1 $(LDFLAGS) #' \
		-e 's/-Wl,[^ ]*//g' \
		-e 's#-llua5.1#$(LUA_LINK_LIB)#g' \
		-i Makefile

	sed \
		-e "s#lua5.1/##" \
		-i src/config.c src/lfuncs.c src/lua.c src/lua-fastcgi.c
}

each_lua_install() {
	newbin ${PN} ${PN}-${TARGET}
#-${ABI} #is it needed?
}
