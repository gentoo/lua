# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
VCS="git-r3"

# Incompatible with current mongo-driver

# FIXME: when libmongo-drivers will be multilib
#IS_MULTILIB=true

inherit lua

DESCRIPTION="Lua driver for MongoDB"
HOMEPAGE="https://github.com/mwild1/luamongo/"
SRC_URI=""

EGIT_REPO_URI="https://github.com/moai/luamongo"

LICENSE="MIT"
SLOT="0"
KEYWORDS="-*"
IUSE="+examples"

RDEPEND="
	dev-libs/boost
	dev-libs/mongo-cxx-driver
"
#	dev-db/mongodb[sharedclient]
DEPEND="${RDEPEND}"

READMES=( README.md )
EXAMPLES=( tests/ )

all_lua_prepare() {
	# Preparing makefile to default_prepare magic fix
	sed -i -r \
		-e '/^MONGOFLAGS/d' \
		-e '/^LUAPKG/d' \
		-e '/^LUAFLAGS/d' \
		-e '/if . -z /d' \
		-e 's#\$\(shell pkg-config --libs \$\(LUAPKG\)\)#-llua#' \
		Makefile

	lua_default
}

each_lua_configure() {
	myeconfargs=()
	myeconfargs+=(
		LUAPKG="$(lua_get_lua)"
	)
	lua_default
}

each_lua_install() {
	dolua mongo.so
}
