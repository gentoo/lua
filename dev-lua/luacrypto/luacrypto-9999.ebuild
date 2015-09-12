# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

LANGS=" en ru"

VCS=git-r3
IS_MULTILIB=true
LUA_COMPAT="lua51 luajit2"

inherit lua

DESCRIPTION="Lua Crypto Library"
HOMEPAGE="https://github.com/msva/lua-crypto"
SRC_URI=""

EGIT_REPO_URI="https://github.com/msva/lua-crypto.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc +openssl gcrypt"
IUSE+="${LANGS// / linguas_}"

RDEPEND="
	openssl? ( >=dev-libs/openssl-0.9.7 )
	gcrypt? ( dev-libs/libgcrypt )
"

REQUIRED_USE="^^ ( openssl gcrypt )"

READMES=( README )
HTML_DOCS=()

all_lua_prepare() {
		for x in ${LANGS}; do
			if use linguas_${x}; then
				HTML_DOCS+=( doc/${x} )
			fi
		done
}

each_lua_compile() {
	_lua_setCFLAGS

	local engine="openssl";
	if use gcrypt; then
		engine="gcrypt"
		tc-getPROG GCRYPT_CONFIG libgcrypt-config
	fi

	emake LUA_IMPL="${lua_impl}" CC="${CC}" CRYPTO_ENGINE="${engine}" CFLAGS="${CFLAGS}" LDFLAGS="${LDFLAGS}" PKG_CONFIG="${PKG_CONFIG}" GCRYPT_CONFIG="${GCRYPT_CONFIG}"
}

each_lua_install() {
	dolua src/crypto.so
}
