# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

VCS="git-r3"
inherit lua

DESCRIPTION="Streaming reader and parser for HTTP file uploading based on ngx_lua cosocket"
HOMEPAGE="https://github.com/openresty/lua-resty-upload"
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
