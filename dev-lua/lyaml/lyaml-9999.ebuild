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
DEPEND="${RDEPEND}"

DOCS=(README.md NEWS.md)
HTML_DOCS=(html/.)

all_lua_prepare() {
	sed -r \
		-e "s/@PACKAGE_STRING@/${P}/" \
		-e '/^dir/s@"."@"../html"@' \
		build-aux/config.ld.in > build-aux/config.ld

	gawk \
		'/^AC_INIT/{print gensub(/[^0-9.]*([0-9.]*)[^0-9.]*/,"#define VERSION \"\\1\"","g",$2)}' \
		configure.ac > config.h
}

each_lua_compile() {
	_lua_setFLAGS

	# CRAZY buildsystem, no thanks
	for c in ext/yaml/*.c; do
		"${CC}" ${CFLAGS} -I. -c -o "${c/.c/.o}" "${c}" || die
	done;

    "${CC}" ${LDFLAGS} $(${PKG_CONFIG} --libs yaml-0.1) -o "${PN:1}.so" ext/yaml/*.o || die
}


all_lua_compile() {
    use doc && (
		pushd build-aux &>/dev/null
		ldoc .
		popd
	)
}

each_lua_install() {
	dolua "${PN:1}.so"
}

#each_lua_configure() {
#	myeconfargs=(
#		LUA="$(lua_get_lua)"
#		LUA_INCLUDE="$(lua_get_pkgvar --cflags --cflags-only-I)"
#		ax_cv_lua_luadir="$(lua_get_pkgvar INSTALL_LMOD)"
#		ax_cv_lua_luaexecdir="$(lua_get_pkgvar INSTALL_CMOD)"
#		--datadir="$(lua_get_pkgvar INSTALL_LMOD)"
#		--libdir="$(lua_get_pkgvar INSTALL_CMOD)"
#	)
#	lua_default
#	econf ${myeconfargs[@]}
#}
