# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

VCS="git-r3"
LUA_COMPAT="luajit2"
inherit lua

DESCRIPTION="LuaJIT FFI-based Random Library for OpenResty"
HOMEPAGE="https://github.com/bungle/lua-resty-random"
SRC_URI=""

EGIT_REPO_URI="https://github.com/bungle/lua-${PN}"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	!dev-lua/resty-string[-ext-random(+)]
	www-servers/nginx[nginx_modules_http_lua,ssl]
	dev-libs/openssl
"
DEPEND="
	${RDEPEND}
"

READMES=( README.md )

each_lua_install() {
#	mv lib/resty/random.lua lib/resty/resty_random.lua
	dolua_jit lib/resty
}
