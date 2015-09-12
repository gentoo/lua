# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

VCS="git-r3"
inherit lua

DESCRIPTION="A small lua module to generate CAPTCHA images using lua-gd"
HOMEPAGE="https://github.com/mrDoctorWho/lua-captcha"
SRC_URI=""

EGIT_REPO_URI="https://github.com/mrDoctorWho/lua-${PN}"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="jpeg png +examples"

READMES=( README.md )
EXAMPLES=( examples/* )

RDEPEND="
	dev-lua/lua-gd
	media-libs/gd[jpeg=,truetype,png=]
"

REQUIRED_USE="|| ( jpeg png )"

each_lua_install() {
	dolua src/*
}

