# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit autotools eutils git-r3

DESCRIPTION="inotify bindings for Lua"
HOMEPAGE="https://github.com/hoelzro/linotify"
SRC_URI=""

EGIT_REPO_URI="https://github.com/hoelzro/linotify.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="luajit"

RDEPEND="virtual/lua[luajit=]"
DEPEND="${RDEPEND}"

src_prepare() {
	epatch_user
}

src_compile() {
	LUAPKG_CMD="lua";
	use luajit && LUAPKG_CMD="luajit";
	export LUAPKG_CMD;
	emake \
		CFLAGS="${CFLAGS} $($(tc-getPKG_CONFIG) ${LUAPKG_CMD} --cflags) -fPIC" \
		|| die "emake failed"
}

src_install() {
	insinto /usr/share/doc/"${P}";
	doins README.md
	emake install \
		DESTDIR="${D}" \
		INSTALL_PATH="$($(tc-getPKG_CONFIG) ${LUAPKG_CMD} --variable=INSTALL_CMOD)" \
	|| die "emake failed"
}
