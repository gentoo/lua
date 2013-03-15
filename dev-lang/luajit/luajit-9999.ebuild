# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit eutils multilib check-reqs pax-utils git-2

DESCRIPTION="Just-In-Time Compiler for the Lua programming language"
HOMEPAGE="http://luajit.org/"
SRC_URI=""
EGIT_REPO_URI="http://luajit.org/git/luajit-2.0.git"

LICENSE="MIT"
SLOT="2"
KEYWORDS=""
IUSE="emacs +optimization symlink +interactive"

CDEPEND="
		symlink? ( =dev-lang/lua-headers-5.1* !dev-lang/lua )
		!symlink? ( =dev-lang/lua-5.1* )
"
DEPEND="
	${CDEPEND}
	emacs? ( app-emacs/lua-mode )
"
PDEPEND="
	interactive? ( dev-lua/iluajit )
	virtual/lua
"

# Workaround for CHECKREQS_MEMORY
pkg_setup() { :; }

pkg_pretend() {
	CHECKREQS_DISK_BUILD="10M"
	use optimization && {
		CHECKREQS_MEMORY="200M"
		ewarn "Optimized build wants at least 200MB of RAM"
		ewarn "If you have no such RAM - try to disable 'optimization' flag"
	}
	check-reqs_pkg_pretend
}

src_prepare(){
	# fixing prefix and version
	sed -e "s|/usr/local|/usr|" \
		-e "s|/lib|/$(get_libdir)|" \
		-e "s|VERSION=.*|VERSION= ${PV}|" \
		-i Makefile || die "failed to fix prefix in Makefile"

	sed -e "s|\(share/luajit\)-[^\"]*|\1-${PV}/|g" \
		-e "s|/usr/local|/usr|" \
		-e "s|lib/|$(get_libdir)/|" \
		-i src/luaconf.h || die "failed to fix prefix in luaconf.h"

	# removing strip
	sed -e '/$(Q)$(TARGET_STRIP)/d' -i src/Makefile \
		|| die "failed to remove forced strip"
	sed -r \
		-e 's#(INSTALL_CMOD=.*)#\1\nINSTALL_INC=${includedir}#' \
		-i etc/luajit.pc || die "failed to fix pkg-config file"
}

src_compile() {
	if use optimization; then
		emake amalg || die "emake failed!"
	else
		emake || die "emake failed!"
	fi
}

src_install() {
	einstall DESTDIR="${D}"
	pax-mark m "${D}usr/bin/luajit-${PV}"
	dosym "luajit-${PV}" "/usr/bin/luajit"
	use symlink && {
	# Spikes
		dosym "luajit-${SLOT}" "/usr/bin/lua"
		exeinto /usr/bin
		newexe "${FILESDIR}/luac.jit" "luac"
		dosym liblua.so.5 /usr/$(get_libdir)/liblua.so
		dosym liblua.so.5.1.9999 /usr/$(get_libdir)/liblua.so.5
		dosym libluajit-5.1.so /usr/$(get_libdir)/liblua.so.5.1.9999
		dosym libluajit-5.1.a /usr/$(get_libdir)/liblua.a
		dosym luajit.pc /usr/$(get_libdir)/pkgconfig/lua.pc
	}
}