# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="4"

MY_P="lua-${PV}"

DESCRIPTION="Lua public API headers."
HOMEPAGE="http://www.lua.org/"
SRC_URI="http://www.lua.org/ftp/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sh ~sparc ~x86 ~x86-fbsd"
IUSE=""

S="${WORKDIR}/${MY_P}"

src_compile() {
	:
}

src_install() {
	insinto /usr/include
	doins src/lua.h src/luaconf.h src/lualib.h src/lauxlib.h etc/lua.hpp \
		|| die 'doins failed.'
}
