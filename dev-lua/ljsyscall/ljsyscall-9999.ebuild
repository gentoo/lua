# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit git-r3 eutils

DESCRIPTION="Lua JSON Library, written in C"
HOMEPAGE="https://github.com/justincormack/ljsyscall"
SRC_URI=""

EGIT_REPO_URI="https://github.com/justincormack/ljsyscall git://github.com/justincormack/ljsyscall"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="test"

RDEPEND="
	dev-lang/luajit:2
	|| (
		sys-libs/glibc[arm=,x86=,amd64=,ppc=,mips=]
		sys-libs/musl[arm=,x86=,amd64=,ppc=,mips=]
		sys-libs/uclibc[arm=,x86=,amd64=,ppc=,mips=]
	)
"
REQUIRED_USE="^^ ( arm x86 amd64 ppc mips )"
DEPEND="${RDEPEND}"

DOCS=( "${S}"/README.md )

src_install() {
	insinto "$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD luajit)"
	doins -r syscall syscall.lua
	default
}
