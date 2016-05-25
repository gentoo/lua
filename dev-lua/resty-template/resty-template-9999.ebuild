# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

VCS="git-r3"
inherit lua

DESCRIPTION="Templating Engine (HTML) for Lua and OpenResty."
HOMEPAGE="https://github.com/bungle/lua-resty-template"
SRC_URI=""

EGIT_REPO_URI="https://github.com/bungle/lua-${PN}"

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

READMES=( "README.md" )

each_lua_install() {
	dolua lib/resty
}
