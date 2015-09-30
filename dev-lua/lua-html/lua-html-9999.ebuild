# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

LUA_COMPAT="lua52"
VCS="git-r3"
IS_MULTILIB=true
inherit lua

DESCRIPTION="lua bindings for HTMLParser in libxml2"
HOMEPAGE="https://github.com/sprhawk/lua-html"
SRC_URI=""

EGIT_REPO_URI="https://github.com/sprhawk/lua-html"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	${DEPEND}
	dev-libs/libxml2
"

READMES=( Readme.md )

all_lua_prepare() {
	lua_default

	# macos thing in linux target
	sed -r \
		-e "s#-undefined dynamic_lookup##g" \
		-i Makefile

	# Wrong case of header name
	sed -r \
		-e 's#libxml/HTMLParser.h#libxml/HTMLparser.h#' \
		-i html.c
}

each_lua_test() {
	${LUA} test.lua
}

each_lua_configure() {
	myeconfargs=()
	myeconfargs+=(
		'CFLAGS+=$(shell $(PKG_CONFIG) --cflags-only-I libxml-2.0)'
		'LDFLAGS+=$(shell $(PKG_CONFIG) --libs-only-L libxml-2.0)'
	)
	lua_default
}

each_lua_install() {
	dolua html.so
}
