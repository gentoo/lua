# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PTV=0.3

DESCRIPTION="modern, legacy free, simple yet efficient vim-like editor"
HOMEPAGE="https://github.com/martanne/vis"
SRC_URI="https://github.com/martanne/vis/releases/download/v${PV}/vis-v${PV}.tar.gz -> ${P}.tar.gz
	test? ( https://github.com/martanne/vis-test/releases/download/v${MY_PTV}/vis-test-${MY_PTV}.tar.gz -> vis-test-${MY_PTV}.tar.gz )"
LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+ncurses lua lpeg selinux test tre"

#TODO: virtual/curses
DEPEND="dev-libs/libtermkey
	lua? ( >=dev-lang/lua-5.2:= )
	ncurses? ( sys-libs/ncurses:= )
	tre? ( dev-libs/tre:= )"
RDEPEND="${DEPEND}
	app-eselect/eselect-vi
	lua? ( lpeg? ( >=dev-lua/lpeg-0.12 ) )"

S="${WORKDIR}/vis-v${PV}"

src_prepare() {
	if use test; then
		rm -r test || die
		mv "${WORKDIR}/vis-test-${MY_PTV}" test || die
		if ! type -P vim &>/dev/null; then
			sed -i 's/.*vim.*//' test/Makefile || die
		fi
	fi

	sed -i 's|STRIP?=.*|STRIP=true|' Makefile || die
	sed -i 's|${DOCPREFIX}/vis|${DOCPREFIX}|' Makefile || die
	sed -i 's|DOCUMENTATION = LICENSE|DOCUMENTATION =|' Makefile || die

	default
}

src_configure() {
	./configure \
		--prefix="${EROOT}usr" \
		--docdir="${EROOT}usr/share/doc/${PF}" \
		$(use_enable lua) \
		$(use_enable ncurses curses) \
		$(use_enable selinux) \
		$(use_enable tre) || die
}

update_symlinks() {
	einfo "Calling eselect vi update --if-unset…"
	eselect vi update --if-unset
}

pkg_postrm() {
	update_symlinks
}

pkg_postinst() {
	update_symlinks
}
