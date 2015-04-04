# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit multilib eutils git-r3 toolchain-funcs

DESCRIPTION="safe-template engine for lua"
HOMEPAGE="https://github.com/mascarenhas/cosmo"
SRC_URI=""

EGIT_REPO_URI="https://github.com/msva/cosmo.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc luajit"

RDEPEND="
	virtual/lua[luajit=]
	|| (
		dev-lua/lpeg
		dev-lua/lulpeg[lpeg-compat]
	)
"
DEPEND="
	${RDEPEND}
	virtual/pkgconfig
"

src_prepare() {
    local lua=lua
    use luajit && lua=luajit
    echo "
        LUA_DIR=$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD ${lua})
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

