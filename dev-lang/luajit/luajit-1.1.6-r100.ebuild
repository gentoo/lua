# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lang/luajit/luajit-1.1.6.ebuild,v 1.1 2010/10/13 00:07:11 rafaelmartins Exp $

EAPI="2"

inherit pax-utils

MY_P="LuaJIT-${PV}"
LUA_PV="5.1.4"

DESCRIPTION="A Just-In-Time Compiler for the Lua programming language."
HOMEPAGE="http://luajit.org/"
SRC_URI="http://luajit.org/download/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="1"
KEYWORDS="~x86"
IUSE="readline"

DEPEND="readline? ( sys-libs/readline )"
RDEPEND="${DEPEND}"
PDEPEND="=dev-lang/lua-headers-${LUA_PV}*"

S="${WORKDIR}/${MY_P}"

src_prepare(){
	# fixing prefix
	sed -i -e "s|/usr/local|${D}usr|" Makefile \
		|| die "failed to fix prefix in Makefile"
	sed -i -e 's|/usr/local/|/usr/|' src/luaconf.h \
		|| die "failed to fix prefix in luaconf.h"

	# forcing the use of our CFLAGS/LDFLAGS
	sed -i -e "s/\$(MYCFLAGS)/\$(MYCFLAGS) ${CFLAGS}/" \
		-e "s/\$(MYLIBS)/\$(MYLIBS) ${LDFLAGS}/" src/Makefile \
		|| die "failed to force the use of the CFLAGS/LDFLAGS from the user"

	# fixing luajit.pc
	sed -i -e 's|/usr/local|/usr|' \
		-e 's/Libs:.*/Libs:/' etc/luajit.pc \
		|| die "failed to fix luajit.pc"
}

src_compile(){
	if use readline; then
		emake linux_rl || die "emake failed."
	else
		emake linux || die "emake failed."
	fi
}

src_install(){
	einstall

	# removing empty dir that was supposed to have the man pages.
	# dev-lang/luajit:1 doesn't install man pages.
	rm -rf "${D}usr/man"

	mv "${D}"usr/bin/luajit{,"${SLOT}"} || die "mv failed!"
	pax-mark m "${D}usr/bin/luajit${SLOT}"

	dodoc README
	dohtml -r jitdoc/*

	insinto /usr/share/pixmaps
	newins etc/luajit.ico "luajit${SLOT}.ico"
	insinto /usr/$(get_libdir)/pkgconfig
	newins etc/luajit.pc "luajit${SLOT}.pc"
}

pkg_postinst(){
	elog
	elog 'If you want to compile something against liblua and use it with'
	elog "this version of LuaJit, please install =dev-lang/lua-${PV}"
	elog 'and use eselect lua to make it the default.'
	elog
}
