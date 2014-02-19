# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit base toolchain-funcs flag-o-matic eutils mercurial

DESCRIPTION="LuaJIT FFI bindings to net-dns/unbound"
HOMEPAGE="http://code.zash.se/luaunbound/"
EHG_REPO_URI="http://code.zash.se/luaunbound/"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="prosody"

RDEPEND="
	dev-lang/luajit:2
	net-dns/unbound
	prosody? (
		net-im/prosody
	)
"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

DOCS=( "README.markdown" )

src_install() {
	insinto "$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD luajit)"
	doins "lib.unbound.lua"
	if use prosody; then
		./squish.sh > use_unbound.lua
		insinto "/etc/jabber"
		doins "use_unbound.lua"	
	fi
	base_src_install_docs
}

pkg_postinst() {
	if use prosody; then
		einfo ""
		einfo "Add following 3 lines to global section of your prosody.cfg.lua:"
		echo 'RunScript "use_unbound.lua"'
		echo 'resolvconf = "/etc/resolv.conf"'
		echo 'hoststxt = "/etc/hosts"'
		echo ''
		einfo "Alternatively, you can customize resolv.conf and hosts files locations"
	fi
}