# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit multilib eutils git-r3 toolchain-funcs

DESCRIPTION="MVC Web Framework for Lua"
HOMEPAGE="https://github.com/keplerproject/orbit"
SRC_URI=""

EGIT_REPO_URI="https://github.com/keplerproject/orbit.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="luajit doc"

RDEPEND="
	virual/lua[luajit=]
	dev-lua/wsapi
	dev-lua/cosmo
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
    local lua=lua
    use luajit && lua=luajit
    sed -r \
        -e "s/^M//g" \
        -e "1s%#!#.*lua$%#!/usr/bin/env ${lua}%g" \
        -i src/launchers/ob{.cgi,.fcgi} src/launchers/orbit
    echo "
        BIN_DIR=${ED}/usr/bin
        LUA_DIR=${ED}/$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD ${lua})
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

