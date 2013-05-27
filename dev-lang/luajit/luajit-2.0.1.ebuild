# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit eutils multilib flag-o-matic check-reqs pax-utils

MY_P="LuaJIT-${PV/_/-}"
DESCRIPTION="Just-In-Time Compiler for the Lua programming language"
HOMEPAGE="http://luajit.org/"
SRC_URI="http://luajit.org/download/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE="+optimization lua52compat"

DEPEND=""
PDEPEND="
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

	use lua52compat && sed \
		-e "/LUAJIT_ENABLE_LUA52COMPAT/s|#||" \
		-i src/Makefile || die

	# removing strip
	sed -e '/$(Q)$(TARGET_STRIP)/d' -i src/Makefile \
		|| die "failed to remove forced strip"

	# fixing pkg-config file (Lua-replacing compatibility)
	sed -r \
		-e 's#(INSTALL_CMOD=.*)#\1\nINSTALL_INC=${includedir}#' \
		-i etc/luajit.pc || die "failed to fix pkgconfig file"

	epatch "${FILESDIR}/v${PV}_hotfix1.patch"
}

src_compile() {
	if has_version '=sys-devel/gcc-4.7.3' && gcc-specs-pie && has ccache ${FEATURES}; then
		# It is three ways to avoid compilation breaking
		# in case, when user use gcc-4.7.3+pie+ccache:
		# a) append -fPIC to CFLAGS, to use it even for temporary
		# build-time only static host/* bins and luajit binary itself.
		# b) append -nopie to LDFLAGS
		#    (for same binaries and same reason)
		# c) disable ccache (even in per-package basis).
		#    This will slow down amalgamated build, but is prefered and
		#    recommended by upstream method.
		# So, since it is impossible to use method "c" directly from
		# ebuild, I choose method "a"
		# (since it is more secure on hardened systems, imho) +
		# + ewarn user, that he really should disable ccache.

#	       append-ldflags -nopie
		append-cflags -fPIC
		ewarn "As we detected, that you're using gcc-4.7.3+pie+ccache,"
		ewarn "we need to either:"
		ewarn "  a) add -fPIC to CFLAGS, or"
		ewarn "  b) add -nopie to LDFLAGS, or"
		ewarn "  c) disable ccache (even on per-package basis)."
		ewarn ""
		ewarn "We suggest you to use variant 'c' and disable it via"
		ewarn "/etc/portage/{,package.}env (read portage manual)"
		ewarn ""
		ewarn "But, since we can't do that from ebuild, we'll continue"
		ewarn "with -fPIC (variant 'a') for now, since it gives more security"
		ewarn "on hardened systems (in our opinion)."
		ewarn ""
		ewarn "But, anyway, we still *HIGHLY* recommend you"
		ewarn "to disable ccache instead."
	fi

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

pkg_postinst() {
	if ! has_version dev-lua/iluajit; then
		einfo "You'd probably want to install dev-lua/iluajit to";
		ewarn "get fully functional interactive shell for LuaJIT";
	fi
	if has_version app-editors/emacs || app-editors/xemacs; then
		einfo "You'd probably want to install app-emacs/lua-mode to";
		ewarn "get Lua completion in emacs.";
	fi
}