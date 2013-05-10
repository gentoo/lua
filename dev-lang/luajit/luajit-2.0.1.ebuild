# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit eutils multilib check-reqs pax-utils

MY_P="LuaJIT-${PV/_/-}"
DESCRIPTION="Just-In-Time Compiler for the Lua programming language"
HOMEPAGE="http://luajit.org/"
SRC_URI="http://luajit.org/download/${MY_P}.tar.gz"

KEYWORDS="~amd64 ~x86"

LICENSE="MIT"
SLOT="2"
IUSE="emacs +optimization +interactive"

CDEPEND="
		|| ( =dev-lang/lua-headers-5.1* dev-lang/lua )
"
DEPEND="
	${CDEPEND}
	emacs? ( app-emacs/lua-mode )
"
PDEPEND="
	interactive? ( dev-lua/iluajit )
	virtual/lua[luajit]
"

S="${WORKDIR}/${MY_P}"

# Workaround for CHECKREQS_MEMORY
pkg_setup() { :; }

pkg_pretend() {
	CHECKREQS_DISK_BUILD="10M"
	use optimization && {
		CHECKREQS_MEMORY="200M"
		ewarn "Optimized (amalgamated) build wants at least 200MB of RAM"
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
		-i etc/luajit.pc || die "failed to fix pkgconfig file"

	epatch "${FILESDIR}/v${PV}_hotfix1.patch"
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
	pax-mark m "${D}usr/bin/${P}"
	dosym "luajit-${PV}" "/usr/bin/${PN}"
	newbin "${FILESDIR}/luac.jit" "luac-${P}"
}

#pkg_postinst() {
#	"${ROOT}"/usr/bin/eselect lua set "${P}"
#}