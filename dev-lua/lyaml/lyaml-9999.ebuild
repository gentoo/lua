# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

VCS="git-r3"
inherit lua

DESCRIPTION="LibYAML binding for Lua."
HOMEPAGE="https://github.com/gvvaughan/lyaml"
SRC_URI=""

EGIT_REPO_URI="https://github.com/gvvaughan/lyaml"

LICENSE="GPL"
SLOT="0"
KEYWORDS=""
IUSE="doc"

RDEPEND="
	dev-libs/libyaml
"
DEPEND="${RDEPEND}"

READMES=( README.md NEWS.md )
HTML_DOCS=( doc/. )

all_lua_prepare() {
	if [[ -n ${EVCS_OFFLINE} ]]; then
		die "Unfortunately, upstream uses buildsystem which depends on external submodules, so you won't be able to build package in offline mode. Sorry."
	fi

    # we'll check for ldoc ourslves
    sed -r \
        -e "s#(AC_PATH_PROG\(\[LDOC\],).*#\1 [echo], [false]\)#" \
        -e "s#(AM_CONDITIONAL\(\[HAVE_LDOC\],).*#\1 [false]\)#" \
        -i configure.ac

    # we don't need and install documentation for each target, so we'll take care on this ourselves
    sed -r \
        -e 's#doc/.*html##' \
        -e 's#doc/.*css##' \
        -e 's#(mkdir)#\1 -p#' \
        -e 's#^(doc:).*##' \
        -e 's#\$\(dist_.*_DATA\)##g' \
        -i local.mk

	./bootstrap --skip-rock-checks

	#unneded bootstrap wrapper
    rm GNUmakefile
}

all_lua_compile() {
    use doc && (
        cp build-aux/config.ld.in build-aux/config.ld

        sed -r \
            -e "s/@PACKAGE_STRING@/${P}/" \
            -i build-aux/config.ld

        cd build-aux && ldoc -d ../doc . && cd ..

        rm build-aux/config.ld
    )
}

each_lua_configure() {
	myeconfargs=(
		LUA="$(lua_get_lua)"
		LUA_INCLUDE="$(lua_get_pkgvar --cflags --cflags-only-I)"
		ax_cv_lua_luadir="$(lua_get_pkgvar INSTALL_LMOD)"
		ax_cv_lua_luaexecdir="$(lua_get_pkgvar INSTALL_CMOD)"
		--datadir="$(lua_get_pkgvar INSTALL_LMOD)"
		--libdir="$(lua_get_pkgvar INSTALL_CMOD)"
	)
	base_src_configure "${myeconfargs[@]}"

#	)
#		"LUA_INCLUDE=-I$(lua_get_pkgvar includedir)"
#	lua_default
#	econf ${myeconfargs[@]}
}
