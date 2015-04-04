# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit multilib eutils git-r3 toolchain-funcs

DESCRIPTION="Lua WSAPI Library"
HOMEPAGE="https://github.com/keplerproject/wsapi"
SRC_URI=""

EGIT_REPO_URI="https://github.com/keplerproject/wsapi.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="luajit doc uwsgi +fcgi"
#TODO: xavante"
RDEPEND="
	virtual/lua[luajit=]
	fcgi? (
		dev-libs/fcgi
		virtual/httpd-fastcgi
	)
	uwsgi? (
		www-servers/uwsgi
	)
	dev-lua/rings
	dev-lua/coxpcall
"
#TODO:	xavante? ( dev-lua/xavante )"
DEPEND="${RDEPEND}"

src_prepare() {
	local lua=lua
	use luajit && lua=luajit
	sed -r \
		-e "s///g" \
		-e "1s%#!#.*lua$%#!/usr/bin/env ${lua}%g" \
		-i src/launcher/wsapi{,.cgi,.fcgi}
	echo "
		LIB_OPTION=-shared -fPIC
		BIN_DIR=/usr/bin
		LUA_DIR=$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD ${lua})
		LUA_LIBDIR=$($(tc-getPKG_CONFIG) --variable INSTALL_CMOD ${lua})
		INC=-I$($(tc-getPKG_CONFIG) --variable includedir ${lua})
		CC=$(tc-getCC) -fPIC -DPIC
		LDFLAGS=${LDFLAGS}
		CFLAGS=${CFLAGS}
		DESTDIR=${ED}
	" > "${S}/config"
}

src_configure() {
	:
}

src_install() {
	docompress -x /usr/share/doc
	default
	use doc && (
		insinto /usr/share/doc/${PF}/examples
		doins -r samples/*
		insinto /usr/share/doc/${PF}
		doins -r doc/*
	)
}
