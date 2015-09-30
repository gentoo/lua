# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

LANGS=( "en" "ru" )

VCS=git-r3
IS_MULTILIB=true

inherit lua

DESCRIPTION="Lua Crypto Library"
HOMEPAGE="https://github.com/msva/lua-crypto"
SRC_URI=""

EGIT_REPO_URI="https://github.com/msva/lua-crypto.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="doc +openssl gcrypt linguas_en linguas_ru"

RDEPEND="
	openssl? ( >=dev-libs/openssl-0.9.7 )
	gcrypt? ( dev-libs/libgcrypt )
"

REQUIRED_USE="^^ ( openssl gcrypt )"

READMES=( README )
HTML_DOCS=()

all_lua_prepare() {
		for x in ${LANGS[@]}; do
			if use linguas_${x}; then
				HTML_DOCS+=( doc/${x} )
			fi
		done
}

each_lua_compile() {
	local engine="openssl";
	if use gcrypt; then
		engine="gcrypt"
		tc-getPROG GCRYPT_CONFIG libgcrypt-config
	fi

	lua_default \
		LUA_IMPL="${lua_impl}" \
		CRYPTO_ENGINE="${engine}" \
		GCRYPT_CONFIG="${GCRYPT_CONFIG}"
}

each_lua_install() {
	dolua src/crypto.so
}
