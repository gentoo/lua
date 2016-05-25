# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

LUA_COMPAT="luajit2"
VCS="git-r3"
inherit lua

DESCRIPTION="New LuaJIT FFI based API for lua-nginx-module"
HOMEPAGE="https://github.com/openresty/lua-resty-core"
SRC_URI=""

EGIT_REPO_URI="https://github.com/openresty/lua-${PN}"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	virtual/lua[luajit]
	www-servers/nginx[nginx_modules_http_lua]
	dev-lua/resty-lrucache
"
DEPEND="
	${RDEPEND}
"

READMES=( README.markdown )

each_lua_install() {
	dolua_jit lib/resty
}
