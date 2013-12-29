# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit base multilib pax-utils versionator toolchain-funcs flag-o-matic check-reqs git-r3

MY_PV="2.0.2"

DESCRIPTION="Just-In-Time Compiler for the Lua programming language"
HOMEPAGE="http://luajit.org/"
SRC_URI=""
EGIT_REPO_URI="git://repo.or.cz/luajit-2.0.git"

LICENSE="MIT"
SLOT="2"
KEYWORDS=""
IUSE="lua52compat +optimization"

DEPEND=""
PDEPEND="
	virtual/lua[luajit]
"

HTML_DOCS=( "doc/" )

check_req() {
	if use optimization; then
		CHECKREQS_MEMORY="200M"
		ewarn "Optimized (amalgamated) build wants at least 200MB of RAM"
		ewarn "If you have no such RAM - try to disable 'optimization' flag"
		check-reqs_pkg_${1}
	fi
}

pkg_pretend() {
	check_req pretend
}

pkg_setup() {
	check_req setup
}

src_prepare(){
	# fixing prefix and version
	sed -r \
		-e "s|( PREFIX)=.*|\1=/usr|" \
		-e "s|( MULTILIB)=.*|\1=$(get_libdir)|" \
		-i Makefile || die "failed to fix prefix in Makefile"
}

src_compile() {
	local opt;
	use optimization && opt="amalg";

	if gcc-fullversion 4 7 3 && gcc-specs-pie && has ccache ${FEATURES}; then
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

	emake \
		Q= \
		HOST_CC="$(tc-getBUILD_CC)" \
		STATIC_CC="$(tc-getCC)" \
		DYNAMIC_CC="$(tc-getCC) -fPIC" \
		TARGET_LD="$(tc-getCC)" \
		TARGET_AR="$(tc-getAR) rcus" \
		TARGET_STRIP="true" \
		XCFLAGS="$(usex lua52compat "-DLUAJIT_ENABLE_LUA52COMPAT" "")" \
		"${opt}"
}

src_install() {
	default
	base_src_install_docs

	host-is-pax && pax-mark m "${ED}usr/bin/${PN}-${MY_PV}"
	dosym "${PN}-${MY_PV}" "/usr/bin/${PN}"
	dobin "${FILESDIR}/luac.jit"
}