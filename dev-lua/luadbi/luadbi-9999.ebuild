# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit multilib toolchain-funcs flag-o-matic eutils mercurial

DESCRIPTION="DBI module for Lua"
HOMEPAGE="https://code.google.com/p/luadbi"
#EHG_REPO_URI="https://code.google.com/p/luadbi"
EHG_REPO_URI="https://bitbucket.org/mva/luadbi-temp"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="mysql postgres sqlite luajit"

RDEPEND="	|| ( >=dev-lang/lua-5.1 dev-lang/luajit:2 )
		mysql? ( || ( dev-db/mysql dev-db/mariadb ) )
		postgres? ( dev-db/postgresql-base )
		sqlite? ( >=dev-db/sqlite-3 )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

S="${WORKDIR}"

src_compile() {
	local lua=lua;
	use luajit && lua=luajit;

	local drivers=""
	use mysql && drivers="${drivers} mysql"
	use postgres && drivers="${drivers} psql"
	use sqlite && drivers="${drivers} sqlite3"

	if [ -z "${drivers// /}" ] ; then
		eerror
		eerror "No driver was selected, cannot build."
		eerror "Please set USE flags to build any driver."
		eerror "Possible USE flags: mysql postgres sqlite"
		eerror
		die "No driver selected"
	fi

	for driver in "${drivers}" ; do
		emake \
			CC="$(tc-getCC) -fPIC -DPIC" \
			LDFLAGS="${LDFLAGS}" \
			CFLAGS="${CFLAGS}"  \
			LUA_LMOD="$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD ${lua})" \
			LUA_CMOD="$($(tc-getPKG_CONFIG) --variable INSTALL_CMOD ${lua})" \
			LUA_INC="-I$($(tc-getPKG_CONFIG) --variable includedir ${lua})" \
			PSQL_INC="-I/usr/include/postgresql/server" \
			MYQL_INC="-I/usr/include/mysql" \
			${driver} \
			|| die "Compiling driver '${drivers// /}' failed"
	done
}

src_install() {
	local drivers=""
	use mysql && drivers="${drivers} mysql"
	use postgres && drivers="${drivers} psql"
	use sqlite && drivers="${drivers} sqlite3"

	for driver in ${drivers} ; do
		emake DESTDIR="${D}" "install_${driver// /}" \
			|| die "Install of driver '${drivers// /}' failed"
	done
}
