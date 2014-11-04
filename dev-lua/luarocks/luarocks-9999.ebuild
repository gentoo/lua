# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit eutils toolchain-funcs git-r3

DESCRIPTION="A deployment and management system for Lua modules"
HOMEPAGE="http://www.luarocks.org"
EGIT_REPO_URI="git://github.com/keplerproject/luarocks.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="curl openssl luajit"

DEPEND="
		!luajit? ( >=dev-lang/lua-5.1 )
		luajit? ( dev-lang/luajit:2 )
		curl? ( net-misc/curl )
		openssl? ( dev-libs/openssl )
"
RDEPEND="${DEPEND}
		app-arch/unzip
		dev-util/pkg-config
"

src_configure() {
	local lua=lua md5="md5sum" downloader="wget"

	use curl && downloader="curl"
	use openssl && md5="openssl"
	use luajit && lua="luajit"

	# econf doesn't work b/c it passes variables the custom configure can't
	# handle
	./configure \
			--prefix=/usr \
			--with-lua=/usr \
			--with-lua-lib=/usr/$(get_libdir) \
			--rocks-tree=/usr \
			--with-downloader="${downloader}" \
			--with-md5-checker="${md5}" \
			$(use luajit && echo "--lua-suffix=jit") \
			--with-lua-include="$($(tc-getPKG_CONFIG) --variable includedir ${lua})" \
			--force-config || die "configure failed"
}

pkg_preinst() {
	find "${D}" -type f | xargs sed -i -e "s:${D}::g" || die "sed failed"
}
