# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

VCS="git-r3"
inherit lua

DESCRIPTION="A deployment and management system for Lua modules"
HOMEPAGE="http://www.luarocks.org"
EGIT_REPO_URI="https://github.com/keplerproject/luarocks.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="curl openssl"

DEPEND="
	curl? ( net-misc/curl )
	!curl? ( net-misc/wget )
	openssl? ( dev-libs/openssl )
	!openssl? ( sys-apps/coreutils )
"
RDEPEND="
	${DEPEND}
	app-arch/unzip
"

all_lua_prepare() {
	sed -r \
		-e "/die.*Unknown flag:/d" \
		-i configure
}

each_lua_configure() {
	local md5 downloader lua incdir
	md5="md5sum"
	downloader="wget"
	lua="$(lua_get_lua)"
	incdir=$(lua_get_pkgvar includedir)

	use curl && downloader="curl"
	use openssl && md5="openssl"

	myeconfargs=()
	myeconfargs+=(
		--prefix=/usr
		--with-lua=/usr
		--with-lua-lib="/usr/$(get_libdir)"
		--rocks-tree=/usr
		--with-downloader="${downloader}"
		--with-md5-checker="${md5}"
		--lua-suffix="${lua//lua}"
		--lua-version="$(lua_get_abi)"
		--with-lua-include="${incdir}"
		--sysconfdir=/etc/${PN}
	)
	lua_default
}

pkg_preinst() {
	find "${D}" -type f | xargs sed -e "s:${D}::g" -i || die "sed failed"
}
