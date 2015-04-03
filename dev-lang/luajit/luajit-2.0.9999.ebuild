# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit base eutils multilib multilib-minimal portability pax-utils toolchain-funcs versionator flag-o-matic check-reqs git-r3

DESCRIPTION="Just-In-Time Compiler for the Lua programming language"
HOMEPAGE="http://luajit.org/"
SRC_URI=""
EGIT_REPO_URI="git://repo.or.cz/luajit-2.0.git"
SLOT="2.0"
#EGIT_BRANCH="v${SLOT}"

LICENSE="MIT"
KEYWORDS=""
IUSE="debug valgrind lua52compat +optimization"

RDEPEND="
	valgrind? ( dev-util/valgrind )
"
DEPEND="${RDEPEND}"

PDEPEND="
	virtual/lua[luajit]
"

HTML_DOCS=( "doc/" )

MULTILIB_WRAPPED_HEADERS=(
    /usr/include/luajit-${SLOT}/luaconf.h
)


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
		-e 's|(VERSION)=.*|\1=$(MAJVER).$(MINVER)|' \
		-e 's|(FILE_MAN)=.*|\1='${PN}'-$(VERSION).1|' \
		-e 's|\$\(MAJVER\)\.\$\(MINVER\)\.\$\(RELVER\)|$(VERSION)|' \
		-e 's|(INSTALL_PCNAME)=.*|\1='${PN}'-$(VERSION).pc|' \
		-e 's|( PREFIX)=.*|\1=/usr|' \
		-i Makefile || die "failed to fix prefix in Makefile"
#		-e "s|( MULTILIB)=.*|\1=$(get_libdir)|" \


	use debug && (
		sed -r \
			-e 's/#(CCDEBUG= -g)/\1 -ggdb/' \
			-i src/Makefile || die "Failed to enable debug"
		)
	mv "${S}"/etc/${PN}.1 "${S}"/etc/${PN}-${SLOT}.1

	multilib_copy_sources
}

multilib_src_compile() {
	local opt xcflags;
	use optimization && opt="amalg";

	tc-export CC
#		STATIC_CC="$(tc-getCC)" \
#		DYNAMIC_CC="$(tc-getCC) -fPIC" \
#		TARGET_LD="$(tc-getCC)" \
#		TARGET_AR="$(tc-getAR) rcus" \

	xcflags=(
		$(usex lua52compat "-DLUAJIT_ENABLE_LUA52COMPAT" "")
		$(usex debug "-DLUAJIT_USE_GDBJIT" "")
		$(usex valgrind "-DLUAJIT_USE_VALGRIND" "")
		$(usex valgrind "-DLUAJIT_USE_SYSMALLOC" "")
	)

	emake \
		Q= \
		HOST_CC="$(tc-getCC)" \
		CC="${CC}" \
		TARGET_STRIP="true" \
		XCFLAGS="${xcflags[*]}" "${opt}"
}

multilib_src_install() {
	local lua_abi="5.1";
	emake DESTDIR="${D}" MULTILIB="$(get_libdir)" install

	base_src_install_docs

	host-is-pax && pax-mark m "${ED}usr/bin/${PN}-${SLOT}"
	dosym "${PN}-${SLOT}" "/usr/bin/${PN}"
	dosym "lib${PN}-${lua_abi}.so.${SLOT}" "/usr/$(get_libdir)/lib${PN}-${SLOT}.so" 
	dosym "${PN}-${SLOT}.1" "/usr/share/man/man1/luacjit-${SLOT}.1"
	newbin "${FILESDIR}/luac.jit" "luacjit-${SLOT}"
}
