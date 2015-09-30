# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

VCS="git-r3"
IS_MULTILIB=true
#AT_NOEAUTOMAKE=yes

inherit autotools lua

DESCRIPTION="POSIX binding, including curses, for Lua 5.1 and 5.2"
HOMEPAGE="https://github.com/luaposix/luaposix"
SRC_URI=""

EGIT_REPO_URI="https://github.com/luaposix/luaposix.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc +examples ncurses"

RDEPEND="
	virtual/lua[bit]
	ncurses? ( sys-libs/ncurses )
"

DEPEND="
	${RDEPEND}
	doc? ( dev-lua/ldoc )
	dev-libs/gnulib
"
#	dev-lua/specl
#	dev-lua/lyaml

READMES=( README.md NEWS.md )
EXAMPLES=( examples/ )
HTML_DOCS=( doc/ )

all_lua_prepare() {
	[[ -n "${EGIT_OFFLINE}" ]] && die "Upstream unfortunately uses buildsystem, which requires to fetch some git "

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

	myeprepareargs=(
		--skip-rock-checks
		--gnulib-srcdir=/usr/share/gnulib
		-Wnone
	)
		#--skip-git
#	AT_NOEAUTOMAKE=yes
#	gnulib-tool  --no-changelog --avoid=dummy --aux-dir=build-aux --m4-base=m4 --source-base=unused --libtool --symlink --import warnings manywarnings
#	eautoreconf

	./bootstrap "${myeprepareargs[@]}"

	# Unneded wrapper over ./bootstrap+./configure
	rm GNUmakefile; ls
}

all_lua_compile() {
	use doc && (
		cp build-aux/config.ld.in build-aux/config.ld
		cp lib/posix.lua.in lib/posix/init.lua

		sed -r \
			-e "s/@PACKAGE_STRING@/${P}/" \
			-i build-aux/config.ld lib/posix/init.lua

		cd build-aux && ldoc -d ../doc . && cd ..

		rm build-aux/config.ld lib/posix/init.lua
	)
}

each_lua_configure() {
	myeconfargs=(
		"$(use_with ncurses)" \
		LUA="$(lua_get_lua)" \
		LUA_INCLUDE="$(lua_get_pkgvar --cflags --cflags-only-I)" \
		ax_cv_lua_luadir="$(lua_get_pkgvar INSTALL_LMOD)" \
		ax_cv_lua_luaexecdir="$(lua_get_pkgvar INSTALL_CMOD)"
		
	)
	base_src_configure
}

