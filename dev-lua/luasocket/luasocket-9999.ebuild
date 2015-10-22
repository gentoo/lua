# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

VCS="git-r3"
IS_MULTILIB=true

inherit lua

DESCRIPTION="Networking support library for the Lua language."
HOMEPAGE="http://www.tecgraf.puc-rio.br/~diego/professional/luasocket/"
EGIT_REPO_URI="https://github.com/diegonehab/luasocket"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc debug"

DOCS=( NEW README )
HTML_DOCS=( doc/ )

all_lua_prepare() {
	lua_default

	# dirty hack for crazy buildsystem
	sed -r \
		-e '1iinclude ../.lua_eclass_config' \
		-e '/^MYCFLAGS=/d' \
		-e '/^MYLDFLAGS=/d' \
		-e '/^CC=/d' \
		-e '/^LD=/d' \
		-e '/^INSTALL_TOP=/d' \
		-i src/makefile
}

each_lua_configure() {
	local luav="${lua_impl}"
	luav="${luav##lua}"

	myeconfargs=(
		"LUAV=${luav}"
		"CDIR=$(lua_get_pkgvar INSTALL_CMOD)"
		"LDIR=$(lua_get_pkgvar INSTALL_LMOD)"
		'INSTALL_TOP=$(DESTDIR)'
		"COMPAT=COMPAT"
		LD='$(CC)'
	)

	use debug && \
		myeconfargs+=( "DEBUG=DEBUG" )

	use elibc_Winnt && \
		myeconfargs+=( "PLAT=win32" )

	use elibc_Cygwin && \
		myeconfargs+=( "PLAT=mingw" )

	use elibc_Darwin && (
		myeconfargs+=(
			"PLAT=macosx"
			LDFLAGS="-bundle -undefined dynamic_lookup"
		)
		sed \
			-e 's#-[fD]PIC#-fno-common#g' \
			-i .lua_eclass_config
	)

	lua_default

	# dirty hack for crazy buildsystem
	sed -r \
		-e 's#(^CFLAGS=)#MY\1#' \
		-e 's#(^LDFLAGS=)#MY\1#' \
		-i .lua_eclass_config
}

#each_lua_install() {
#	myeinstallargs=()
#	if ! use elibc_Winnt && ! use elibc_Cygwin; then
#		myeinstallargs+=( "install-unix" )
#	fi
#
#	lua_default
#}
