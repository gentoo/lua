# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit base git-r3 toolchain-funcs eutils

DESCRIPTION="POSIX binding, including curses, for Lua 5.1 and 5.2"
HOMEPAGE="https://github.com/luaposix/luaposix"
SRC_URI=""

EGIT_REPO_URI="https://github.com/luaposix/luaposix.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="luajit ncurses"

RDEPEND="
	!luajit? (
		|| (
			(
				=dev-lang/lua-5.1*
				dev-lua/LuaBitOp
			)
			>=dev-lang/lua-5.2
		)
	)
	luajit? ( dev-lang/luajit:2 )
"
#	dev-lua/ldoc
#	dev-lua/specl
#	dev-lua/lyaml

DEPEND="${RDEPEND}"

DOCS=( "README.md" "NEWS" )

src_prepare() {
	if [[ -n ${EVCS_OFFLINE} ]]; then
		die "Unfortunately, upstream uses buildsystem which depends on external submodules, so you won't be able to build package in offline mode. Sorry."
	fi

	sed -r \
		-e "s#(AC_PATH_PROG\(\[LDOC\],).*#\1 [echo], [false]\)#" \
		-e "s#(AM_CONDITIONAL\(\[HAVE_LDOC\],).*#\1 [false]\)#" \
		-i configure.ac

# kludgy, but idk, how to drop that f**n broken documentation build
#		-e 's#^(allhtml =).*#\1#' \
	sed -r \
		-e 's#doc/.*html##' \
		-e 's#doc/.*css##' \
		-e 's#(mkdir)#\1 -p#' \
		-e 's#^(doc:).*##' \
		-e 's#\$\(dist_.*_DATA\)##g' \
		-i local.mk

	./bootstrap --skip-rock-checks
}

src_configure() {
	local lua=lua;
	use luajit && lua=luajit;

	myeconfargs=(
		"--datadir=$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD ${lua})" \
		"--libdir=$($(tc-getPKG_CONFIG) --variable INSTALL_CMOD ${lua})" \
		"$(use_with ncurses)"\
		LUA="${lua}" \
		LUA_INCLUDE="-I$($(tc-getPKG_CONFIG) --variable includedir ${lua})"
	)
	base_src_configure "${myeconfargs[@]}"
}

#src_compile() {
#	emake all-am
#}
#
#src_install() {
#	emake install-am
##	insinto $($(tc-getPKG_CONFIG) --variable includedir ${LUA})"
#}
