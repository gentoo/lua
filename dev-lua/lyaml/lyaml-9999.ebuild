# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

VCS="git"
GITHUB_A="gvvaughan"

inherit autotools lua

DESCRIPTION="LibYAML binding for Lua."
HOMEPAGE="https://github.com/gvvaughan/lyaml"

LICENSE="GPL"
SLOT="0"
KEYWORDS=""
IUSE="doc"

RDEPEND="
	dev-libs/libyaml
"
DEPEND="
	${RDEPEND}
	dev-lua/lua-stdlib
	dev-lua/ldoc
"

DOCS=(README.md NEWS.md)
HTML_DOCS=(html/.)

all_lua_prepare() {
	sed -r \
		-e "s/@package@/${PN}/" \
		-e "s/@version@/${PV}/" \
		-e '/^dir/s@../doc@../html@' \
		-i build-aux/config.ld.in

	sed -r \
		-e '/^ldocs/d' \
		-e '/^external_dependencies/,/\}/s@checksymbol[^ ]*@@' \
		-i lukefile

	cp "${FILESDIR}"/Makefile "${S}"

	lua_default
}

each_lua_configure() {
	local ver="${PV}";
	if [[ "${PV}" == "9999" ]]; then
		ver="git:$(git rev-parse --short @)"
	fi
	local myeconfargs=(
		package="${PN}"
		version="${ver}"
		LUA_INCDIR="$(lua_get_incdir)"
	)
	lua_default
}

each_lua_install() {
	dolua lib/"${PN}"
	dolua linux/"${PN:1}".so
}
