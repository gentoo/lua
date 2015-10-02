# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

VCS="git-r3"
LUA_COMPAT="luajit2"
inherit lua

DESCRIPTION="String utilities and common hash functions for ngx_lua and LuaJIT"
HOMEPAGE="https://github.com/openresty/lua-string"
SRC_URI=""

EGIT_REPO_URI="https://github.com/openresty/lua-${PN}"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="+ext_random"

RDEPEND="
	ext_random? ( dev-lua/resty-random )
	www-servers/nginx[nginx_modules_http_lua,ssl]
	dev-libs/openssl
"
DEPEND="
	${RDEPEND}
"

READMES=( README.markdown )

all_lua_prepare() {
	use ext_random && rm lib/resty/random.lua
}

each_lua_install() {
	dolua_jit lib/resty
}
