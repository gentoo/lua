# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit eutils multilib toolchain-funcs versionator mercurial

DESCRIPTION="Prosody is a flexible communications server for Jabber/XMPP written in Lua."
HOMEPAGE="http://prosody.im/"
EHG_REPO_URI="http://hg.prosody.im/trunk"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc +libevent mysql postgres sqlite +ssl +zlib luajit ipv6 migration -lua52"

DEPEND="
	luajit? (
		dev-lang/luajit:2
	)
	!luajit? (
		lua52? (
			=dev-lang/lua-5.2*
		)
		!lua52? (
			=dev-lang/lua-5.1*
			dev-lua/LuaBitOp
		)
	)
	net-im/jabber-base
	>=net-dns/libidn-1.1
	|| (
		>=dev-libs/openssl-0.9.8z
		>=dev-libs/openssl-1.0.1j
	)
"

RDEPEND="
	${DEPEND}
	dev-lua/luasocket
	ipv6? ( =dev-lua/luasocket-9999 )
	ssl? ( =dev-lua/luasec-9999 )
	dev-lua/luaexpat
	dev-lua/luafilesystem
	mysql? ( >=dev-lua/luadbi-0.5[mysql] )
	postgres? ( >=dev-lua/luadbi-0.5[postgres] )
	sqlite? ( >=dev-lua/luadbi-0.5[sqlite] )
	libevent? ( dev-lua/luaevent )
	zlib? ( dev-lua/lua-zlib )
"

S="${WORKDIR}/${P}"

JABBER_ETC="/etc/jabber"
JABBER_SPOOL="/var/spool/jabber"


DOCS=( -r doc/ HACKERS AUTHORS )

src_prepare() {
	epatch "${FILESDIR}/${PN}-0.8.0-cfg.lua.patch"
	sed -e "s!MODULES = \$(DESTDIR)\$(PREFIX)/lib/!MODULES = \$(DESTDIR)\$(PREFIX)/$(get_libdir)/!" -i Makefile
	sed -e "s!SOURCE = \$(DESTDIR)\$(PREFIX)/lib/!SOURCE = \$(DESTDIR)\$(PREFIX)/$(get_libdir)/!" -i Makefile
	sed -e "s!INSTALLEDSOURCE = \$(PREFIX)/lib/!INSTALLEDSOURCE = \$(PREFIX)/$(get_libdir)/!" -i Makefile
	sed -e "s!INSTALLEDMODULES = \$(PREFIX)/lib/!INSTALLEDMODULES = \$(PREFIX)/$(get_libdir)/!" -i Makefile
	sed -e 's!\(os.execute(\)\(CFG_SOURCEDIR.."/../../bin/prosody"\)\();\)!\1"/usr/bin/prosody"\3!' -i util/prosodyctl.lua
	sed -e 's!\(desired_user = .* or "\)\(prosody\)\(";\)!\1jabber\3!' -i prosodyctl

	use luajit && {
		find . -type f -name "*.lua" -print0 | xargs -0 sed -re "1s%#!.*%#!/usr/bin/env luajit%" -i
	}
}

src_configure() {
	local lua=lua;

	use luajit && {
		myconf="--lua-suffix=jit"
		lua=luajit;
	}

	# the configure script is handcrafted (and yells at unknown options)
	# hence do not use 'econf'
	./configure --prefix="/usr" \
		--ostype=linux \
		--sysconfdir="${JABBER_ETC}" \
		--datadir="${JABBER_SPOOL}" \
		--with-lua-lib=/usr/$(get_libdir) \
		--c-compiler="$(tc-getCC)" --linker="$(tc-getCC)" \
		--cflags="${CFLAGS} -Wall -fPIC -D_GNU_SOURCE" \
		--ldflags="${LDFLAGS} -shared" \
		--runwith="${lua}" \
		--with-lua-include="$($(tc-getPKG_CONFIG) --variable includedir ${lua})" \
		--require-config "${myconf}" || die "configure failed"
}

src_compile() {
	default
	use migration && (
		cd "${S}/tools/migration"
		emake || die "emake migrator fails"
	)
}

src_install() {
	local lua=lua
	use luajit && lua=luajit

	default
	newinitd "${FILESDIR}/${PN}".initd "${PN}"
	insinto /etc/logrotate.d
	newins "${FILESDIR}/${PN}".logrotate "${PN}"

	use migration && (
		cd "${S}/tools/migration"
		DESTDIR="${D}" emake install || die "migrator install failed"
		cd "${S}"
		rm -rf tools/migration
		insinto $($(tc-getPKG_CONFIG) ${lua} --variable INSTALL_LMOD)
		doins tools/erlparse.lua
		rm tools/erlparse.lua
		fowners "jabber:jabber" -R "/usr/$(get_libdir)/${PN}"
		fperms "775" -R "/usr/$(get_libdir)/${PN}"
		insinto "/usr/$(get_libdir)/${PN}"
		doins -r tools
	)
}

src_test() {
	cd tests
	./run_tests.sh
}

pkg_postinst() {
	use migration && (
		einfo 'You have enabled "migration" USE-flag.'
		einfo "If you want to migrate data from Ejabberd server, then"
		einfo "take a look at /usr/$(get_libdir)/${PN}/*{2,to}prosody.lua"
		einfo "migration scripts."
		einfo 'Also, you can find "prosody-migrator" binary as usefull'
		einfo "to migrate data from jabberd14, or between prosody files"
		einfo "storage and SQLite3."
	)
}
