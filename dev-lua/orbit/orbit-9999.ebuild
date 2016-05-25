# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

VCS="git-r3"
inherit lua

DESCRIPTION="MVC Web Framework for Lua"
HOMEPAGE="https://github.com/keplerproject/orbit"
SRC_URI=""

EGIT_REPO_URI="https://github.com/keplerproject/orbit.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc +examples"

RDEPEND="
	dev-lua/wsapi
	dev-lua/cosmo
"
DEPEND="
	${RDEPEND}
"
DOCS=( doc/. )
EXAMPLES=( samples/. test/. )

all_lua_prepare() {
	sed -r \
		-e "s/^M//g" \
		-i src/launchers/ob{.cgi,.fcgi} src/launchers/orbit

	rm samples/pages/doc samples/doc
}

src_configure() { :; }
src_compile() { :; }

each_lua_install() {
	dolua src/${PN}{,.lua}
	dobin src/launchers/${PN}
}
