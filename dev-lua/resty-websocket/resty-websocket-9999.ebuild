# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5


VCS="git-r3"
inherit lua

DESCRIPTION="Lua WebSocket implementation for the NginX lua module"
HOMEPAGE="https://github.com/openresty/lua-resty-websocket"
SRC_URI=""

EGIT_REPO_URI="https://github.com/openresty/lua-${PN}"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	www-servers/nginx[nginx_modules_http_lua]
"
DEPEND="
	${RDEPEND}
"

READMES=( README.markdown )

each_lua_install() {
	dolua lib/resty
}
