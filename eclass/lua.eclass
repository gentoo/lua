# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

# @ECLASS: lua.eclass
# @MAINTAINER:
# mva <lua@mva.name>
# @AUTHOR:
# Author: Vadim A. Misbakh-Soloviov <lua@mva.name>
# @BLURB: An eclass for installing Lua packages with proper support for multiple Lua slots.
# @DESCRIPTION:
# The Lua eclass is designed to allow an easier installation of Lua packages
# and their incorporation into the Gentoo Linux system.
#
# Currently available targets are:
#  * lua51 - Lua (PUC-Rio) 5.1
#  * lua52 - Lua (PUC-Rio) 5.2
#  * lua53 - Lua (PUC-Rio) 5.3
#  * luajit2 - LuaJIT 2.x
#
# This eclass does not define the implementation of the configure,
# compile, test, or install phases. Instead, the default phases are
# used.  Specific implementations of these phases can be provided in
# the ebuild either to be run for each Lua implementation, or for all
# Lua implementations, as follows:
#
#  * each_lua_configure
#  * all_lua_configure

# @ECLASS-VARIABLE: LUA_COMPAT
# @REQUIRED
# @DESCRIPTION:
# This variable contains a space separated list of targets (see above) a package
# is compatible to. It must be set before the `inherit' call.
: ${LUA_COMPAT:=lua51 lua52 lua53 luajit2}

# @ECLASS-VARIABLE: LUA_PATCHES
# @DEFAULT_UNSET
# @DESCRIPTION:
# A String or Array of filenames of patches to apply to all implementations.

# @ECLASS-VARIABLE: LUA_OPTIONAL
# @DESCRIPTION:
# Set the value to "yes" to make the dependency on a Lua interpreter
# optional and then lua_implementations_depend() to help populate
# DEPEND and RDEPEND.

# @ECLASS-VARIABLE: LUA_S
# @DEFAULT_UNSET
# @DESCRIPTION:
# If defined this variable determines the source directory name after
# unpacking. This defaults to the name of the package. Note that this
# variable supports a wildcard mechanism to help with github tarballs
# that contain the commit hash as part of the directory name.

# @ECLASS-VARIABLE: LUA_QA_ALLOWED_LIBS
# @DEFAULT_UNSET
# @DESCRIPTION:
# If defined this variable contains a whitelist of shared objects that
# are allowed to exist even if they don't link to liblua. This avoids
# the QA check that makes this mandatory. This is most likely not what
# you are looking for if you get the related "Missing links" QA warning,
# since the proper fix is almost always to make sure the shared object
# is linked against liblua. There are cases were this is not the case
# and the shared object is generic code to be used in some other way
# (e.g. selenium's firefox driver extension). When set this argument is
# passed to "grep -E" to remove reporting of these shared objects.

[[ -n "${IS_MULTILIB}" ]] && multilib="multilib-minimal"

inherit base eutils ${multilib} toolchain-funcs ${VCS}

EXPORT_FUNCTIONS src_unpack src_prepare src_configure src_compile src_install pkg_setup

case ${EAPI} in
	0|1)
		die "Unsupported EAPI=${EAPI} (too old) for lua.eclass" ;;
	2|3) ;;
	4|5)
		# S is no longer automatically assigned when it doesn't exist.
		S="${WORKDIR}"
		;;
	*)
		die "Unknown EAPI=${EAPI} for lua.eclass"
esac

lua_implementation_depend() {
	local lua_pn=
	local lua_slot=

	case $1 in
		lua51)
			lua_pn="dev-lang/lua"
			lua_slot=":5.1"
			;;
		lua52)
			lua_pn="dev-lang/lua"
			lua_slot=":5.2"
			;;
		lua53)
			lua_pn="dev-lang/lua"
			lua_slot=":5.3"
			;;
		luajit2)
			lua_pn="dev-lang/luajit"
			lua_slot=":2"
			;;
		*) die "$1: unknown Lua implementation"
	esac

	echo "$2${lua_pn}$3${lua_slot}"
}

# @FUNCTION: lua_implementation_command
# @RETURN: the path to the given lua implementation
# @DESCRIPTION:
lua_implementation_command() {
	local _lua_name=
	local _lua_slotted=$(lua_implementation_depend $1)
	_lua_name=${_lua_slotted//:}

	case $1 in
		luajit*)
			_lua_name=${_lua_slotted/:/-}
			;;
	esac

	local lua=$(readlink -fs $(type -p $(basename ${_lua_name} 2>/dev/null)) 2>/dev/null)
	[[ -x ${lua} ]] || die "Unable to locate executable Lua interpreter"
	echo "${lua}"
}

# @FUNCTION: lua_samelib
# @RETURN: use flag string with current lua implementations
# @DESCRIPTION:
# Convenience function to output the use dependency part of a
# dependency. Used as a building block for lua_add_rdepend() and
# lua_add_bdepend(), but may also be useful in an ebuild to specify
# more complex dependencies.
lua_samelib() {
	local res=
	for _lua_implementation in $LUA_COMPAT; do
		has -${_lua_implementation} $@ || \
			res="${res}lua_targets_${_lua_implementation}?,"
	done

	echo "[${res%,}]"
}

_lua_atoms_samelib_generic() {
	eshopts_push -o noglob
	echo "LUATARGET? ("
	for token in $*; do
		case "$token" in
			"||" | "(" | ")" | *"?")
				echo "${token}"
				;;
			*])
				echo "${token%[*}[LUATARGET,${token/*[}"
				#" <= kludge for vim's syntax highlighting engine to don't mess up all
				;;
			*)
				echo "${token}[LUATARGET]"
				;;
		esac
	done
	echo ")"
	eshopts_pop
}

_lua_atoms_samelib() {
	local atoms=$(_lua_atoms_samelib_generic "$*")

	for _lua_implementation in $LUA_COMPAT; do
		echo "${atoms//LUATARGET/lua_targets_${_lua_implementation}}"
	done
}

_lua_wrap_conditions() {
	local conditions="$1"
	local atoms="$2"

	for condition in $conditions; do
		atoms="${condition}? ( ${atoms} )"
	done

	echo "$atoms"
}

# @FUNCTION: lua_add_rdepend
# @USAGE: dependencies
# @DESCRIPTION:
# Adds the specified dependencies, with use condition(s) to RDEPEND,
# taking the current set of lua targets into account. This makes sure
# that all lua dependencies of the package are installed for the same
# lua targets. Use this function for all lua dependencies instead of
# setting RDEPEND yourself. The list of atoms uses the same syntax as
# normal dependencies.
#
# Note: runtime dependencies are also added as build-time test
# dependencies.
lua_add_rdepend() {
	case $# in
		1) ;;
		2)
			[[ "${GENTOO_DEV}" == "yes" ]] && eqawarn "You can now use the usual syntax in lua_add_rdepend for $CATEGORY/$PF"
			lua_add_rdepend "$(_lua_wrap_conditions "$1" "$2")"
			return
			;;
		*)
			die "bad number of arguments to $0"
			;;
	esac

	local dependency=$(_lua_atoms_samelib "$1")

	RDEPEND="${RDEPEND} $dependency"

	# Add the dependency as a test-dependency since we're going to
	# execute the code during test phase.
	DEPEND="${DEPEND} test? ( ${dependency} )"
	has test "$IUSE" || IUSE="${IUSE} test"
}

# @FUNCTION: lua_add_bdepend
# @USAGE: dependencies
# @DESCRIPTION:
# Adds the specified dependencies, with use condition(s) to DEPEND,
# taking the current set of lua targets into account. This makes sure
# that all lua dependencies of the package are installed for the same
# lua targets. Use this function for all lua dependencies instead of
# setting DEPEND yourself. The list of atoms uses the same syntax as
# normal dependencies.
lua_add_bdepend() {
	case $# in
		1) ;;
		2)
			[[ "${GENTOO_DEV}" == "yes" ]] && eqawarn "You can now use the usual syntax in lua_add_bdepend for $CATEGORY/$PF"
			lua_add_bdepend "$(_lua_wrap_conditions "$1" "$2")"
			return
			;;
		*)
			die "bad number of arguments to $0"
			;;
	esac

	local dependency=$(_lua_atoms_samelib "$1")

	DEPEND="${DEPEND} $dependency"
	RDEPEND="${RDEPEND}"
}

# @FUNCTION: lua_get_use_implementations
# @DESCRIPTION:
# Gets an array of lua use targets enabled by the user
lua_get_use_implementations() {
	local i implementation
	for implementation in ${LUA_COMPAT}; do
		use lua_targets_${implementation} && i+=" ${implementation}"
	done
	echo $i
}

# @FUNCTION: lua_get_use_targets
# @DESCRIPTION:
# Gets an array of lua use targets that the ebuild sets
lua_get_use_targets() {
	local t implementation
	for implementation in ${LUA_COMPAT}; do
		t+=" lua_targets_${implementation}"
	done
	echo $t
}

# @FUNCTION: lua_implementations_depend
# @RETURN: Dependencies suitable for injection into DEPEND and RDEPEND.
# @DESCRIPTION:
# Produces the dependency string for the various implementations of lua
# which the package is being built against. This should not be used when
# LUA_OPTIONAL is unset but must be used if LUA_OPTIONAL=yes. Do not
# confuse this function with lua_implementation_depend().
#
# @EXAMPLE:
# EAPI=5
# LUA_OPTIONAL=yes
#
# inherit lua
# ...
# DEPEND="lua? ( $(lua_implementations_depend) )"
# RDEPEND="${DEPEND}"
lua_implementations_depend() {
	local depend
	for _lua_implementation in ${LUA_COMPAT}; do
		depend="${depend}${depend+ }lua_targets_${_lua_implementation}? ( $(lua_implementation_depend $_lua_implementation) )"
	done
	echo "${depend}"
}

IUSE+="$(lua_get_use_targets)"
# If you specify LUA_OPTIONAL you also need to take care of
# lua useflag and dependency.
if [[ ${LUA_OPTIONAL} != yes ]]; then
	DEPEND="${DEPEND} $(lua_implementations_depend)"
	RDEPEND="${RDEPEND} $(lua_implementations_depend)"

	case ${EAPI:-0} in
		4|5)
			REQUIRED_USE+=" || ( $(lua_get_use_targets) )"
			;;
	esac
fi

_lua_invoke_environment() {
	old_S=${S}
	case ${EAPI} in
		4|5)
			if [ -z "${LUA_S}" ]; then
				sub_S=${P}
			else
				sub_S=${LUA_S}
			fi
			;;
		*)
			sub_S=${S#${WORKDIR}/}
			;;
	esac

	# Special case, for the always-lovely GitHub fetches. With this,
	# we allow the star glob to just expand to whatever directory it's
	# called.
	if [[ "${sub_S}" = *"*"* ]]; then
		case ${EAPI} in
			2|3)
				#The old method of setting S depends on undefined package
				# manager behaviour, so encourage upgrading to EAPI=4.
				eqawarn "Using * expansion of S is deprecated. Use EAPI and LUA_S instead."
				;;
		esac
		pushd "${WORKDIR}"/all &>/dev/null
		sub_S=$(eval ls -d "${sub_S}" 2>/dev/null)
		popd &>/dev/null
	fi

	environment=$1; shift

	my_WORKDIR="${WORKDIR}"/${environment}
	S="${my_WORKDIR}"/"${sub_S}"

	if [[ -d "${S}" ]]; then
		pushd "$S" &>/dev/null
	elif [[ -d "${my_WORKDIR}" ]]; then
		pushd "${my_WORKDIR}" &>/dev/null
	else
		pushd "${WORKDIR}" &>/dev/null
	fi

	ebegin "Running ${_PHASE:-${EBUILD_PHASE}} phase for $environment"
	"$@"
	popd &>/dev/null

	S=${old_S}
}

_lua_each_implementation() {
	local invoked=no
	for _lua_implementation in ${LUA_COMPAT}; do
		# only proceed if it's requested
		use lua_targets_${_lua_implementation} || continue

		LUA=$(lua_implementation_command ${_lua_implementation})
		lua_impl=$(basename ${LUA})
		invoked=yes

		if [[ -n "$1" ]]; then
			_lua_invoke_environment ${_lua_implementation} "$@"
		fi

		unset LUA lua_impl
	done

	if [[ ${invoked} == "no" ]]; then
		eerror "You need to select at least one compatible Lua installation target via LUA_TARGETS in make.conf."
		eerror "Compatible targets for this package are: ${LUA_COMPAT}"
		eerror
		die "No compatible Lua target selected."
	fi
}

# @FUNCTION: lua_pkg_setup
# @DESCRIPTION:
# Check whether at least one lua target implementation is present.
lua_pkg_setup() {
	# This only checks that at least one implementation is present
	# before doing anything; by leaving the parameters empty we know
	# it's a special case.
	_lua_each_implementation
}

# @FUNCTION: lua_src_unpack
# @DESCRIPTION:
# Unpack the source archive.
lua_src_unpack() {
	mkdir "${WORKDIR}"/all
	pushd "${WORKDIR}"/all &>/dev/null

	# We don't support an each-unpack, it's either all or nothing!
	if type all_lua_unpack &>/dev/null; then
		_lua_invoke_environment all all_lua_unpack
	elif [[ -n ${A} ]]; then
		unpack ${A}
	elif [[ -n ${VCS} ]] && declare -f ${VCS}_src_unpack >/dev/null; then
			_lua_invoke_environment all ${VCS}_src_unpack
	fi

	# hack for VCS-eclasses (git-r3 and darcs, for now) which defaults unpack dir to WD/P instead of S
	if [[ '*9999*' =~ ${PV} ]] && [[ -d ${WORKDIR}/${P} ]] && [[ ! -d ${WORKDIR}/all/${P} ]] ; then
		mv ${WORKDIR}/${P} ${WORKDIR}/all/${P}
	fi

	popd &>/dev/null
}

_lua_apply_patches() {
	for patch in "${LUA_PATCHES[@]}"; do
		if [ -f "${patch}" ]; then
			epatch "${patch}"
		elif [ -f "${FILESDIR}/${patch}" ]; then
			epatch "${FILESDIR}/${patch}"
		else
			die "Cannot find patch ${patch}"
		fi
	done

	# This is a special case: instead of executing just in the special
	# "all" environment, this will actually copy the effects on _all_
	# the other environments, and is thus executed before the copy
	type all_lua_prepare &>/dev/null && all_lua_prepare
}

_lua_source_copy() {
	# Until we actually find a reason not to, we use hardlinks, this
	# should reduce the amount of disk space that is wasted by this.
	cp -prlP all ${_lua_implementation} \
		|| die "Unable to copy ${_lua_implementation} environment"
}

_lua_setCFLAGS() {
	local lua=$(readlink -fs $(type -p $(basename ${LUA:-lua} 2>/dev/null)) 2>/dev/null)
	CC="$(tc-getCC)"
	CXX="$(tc-getCXX)"
	LD="$(tc-getLD)"
	PKG_CONFIG="$(tc-getPKG_CONFIG)"
	CFLAGS="${CFLAGS} $($(tc-getPKG_CONFIG) --cflags $(basename ${lua})) -fPIC -DPIC"
	CXXFLAGS="${CXXFLAGS} $($(tc-getPKG_CONFIG) --cflags $(basename ${lua})) -fPIC -DPIC"
	LDFLAGS="${LDFLAGS} -shared -fPIC"
	export CC CXX LC CFLAGS CXXFLAGS LDFLAGS PKG_CONFIG
}

# @FUNCTION: lua_src_prepare
# @DESCRIPTION:
# Apply patches and prepare versions for each lua target
# implementation. Also carry out common clean up tasks.
lua_src_prepare() {
	if [[ -n ${VCS} ]] && declare -f ${VCS}_src_prepare >/dev/null; then
			_lua_invoke_environment all ${VCS}_src_prepare
	fi
	_lua_invoke_environment all epatch_user
	_lua_invoke_environment all _lua_apply_patches

	if [[ -n ${IS_MULTILIB} ]]; then
		_lua_invoke_environment all multilib_copy_sources
	fi

	_PHASE="source copy" \
		_lua_each_implementation _lua_source_copy

	if type each_lua_prepare &>/dev/null; then
		_lua_each_implementation each_lua_prepare
	fi
}

# @FUNCTION: lua_src_configure
# @DESCRIPTION:
# Configure the package.
lua_src_configure() {
	if type each_lua_configure &>/dev/null; then
		if [[ -n ${IS_MULTILIB} ]]; then
			multilib_src_configure() {
				each_lua_configure
			}
			_lua_each_implementation multilib-minimal_src_configure
		else
			_lua_each_implementation each_lua_configure
		fi
	fi

	if type all_lua_configure &>/dev/null; then
		if [[ -n ${IS_MULTILIB} ]]; then
			multilib_src_configure() {
				all_lua_configure
			}
			_lua_invoke_environment all multilib-minimal_src_configure
		else
			_lua_invoke_environment all all_lua_configure
		fi
	fi
}

# @FUNCTION: lua_src_compile
# @DESCRIPTION:
# Compile the package.
lua_src_compile() {
	if type each_lua_compile &>/dev/null; then
		if [[ -n ${IS_MULTILIB} ]]; then
			multilib_src_compile() {
				each_lua_compile
			}
			_lua_each_implementation multilib-minimal_src_compile
		else
			_lua_each_implementation each_lua_compile
		fi
	fi

	if type all_lua_compile &>/dev/null; then
		if [[ -n ${IS_MULTILIB} ]]; then
			multilib_src_compile() {
				all_lua_compile
			}
			_lua_invoke_environment all multilib-minimal_src_compile
		else
			_lua_invoke_environment all all_lua_compile
		fi
	fi
}

# @FUNCTION: lua_src_test
# @DESCRIPTION:
# Run tests for the package.
lua_src_test() {
	if type each_lua_test &>/dev/null; then
		if [[ -n ${IS_MULTILIB} ]]; then
			multilib_src_test() {
				each_lua_test
			}
			_lua_each_implementation multilib-minimal_src_test
		else
			_lua_each_implementation each_lua_test
		fi
	fi

	if type all_lua_test &>/dev/null; then
		if [[ -n ${IS_MULTILIB} ]]; then
			multilib_src_test() {
				all_lua_test
			}
			_lua_invoke_environment all multilib-minimal_src_test
		else
			_lua_invoke_environment all all_lua_test
		fi
	fi
}

# @FUNCTION: lua_src_install
# @DESCRIPTION:
# Install the package for each lua target implementation.
lua_src_install() {
	if type each_lua_install &>/dev/null; then
		if [[ -n ${IS_MULTILIB} ]]; then
			multilib_src_install() {
				each_lua_install
			}
			_lua_each_implementation multilib-minimal_src_install
		else
			_lua_each_implementation each_lua_install
		fi
	fi

	if type all_lua_install &>/dev/null; then
		if [[ -n ${IS_MULTILIB} ]]; then
			multilib_src_install() {
				all_lua_install
			}
			_lua_invoke_environment all multilib-minimal_src_install
		else
			_lua_invoke_environment all all_lua_install
		fi
	fi

#### TODO: move this things to more general eclass, like docs or so ####
	local README_DOCS OTHER_DOCS MY_S;

	README_DOCS=(${DOCS[@]});
	OTHER_DOCS=(${DOCS[@]//README*});
	MY_S="${WORKDIR}/all/${P}"
	
	unset DOCS;

	for r in ${OTHER_DOCS[@]}; do
		README_DOCS=("${README_DOCS[@]//${r}}")

		if [[ -d ${MY_S}/${r} ]]; then
			OTHER_DOCS=("${OTHER_DOCS[@]//${r}}")
			for od in ${MY_S}/${r}/*; do
				OTHER_DOCS+=("${od#${MY_S}/}")
			done
		fi
	done;

	README_DOCS+=(${READMES[@]})

	if [[ -n "${README_DOCS}" ]]; then
		export DOCS=(${README_DOCS[@]});
		_PHASE="install readmes" _lua_invoke_environment all base_src_install_docs
		unset DOCS;
	fi

	if [[ -n "${OTHER_DOCS[@]}" || -n "${HTML_DOCS[@]}" ]] && use doc; then
		export DOCS=(${OTHER_DOCS[@]})
		_PHASE="install docs" _lua_invoke_environment all base_src_install_docs
		unset DOCS
	fi

	if [[ -n "${EXAMPLES[@]}" ]] && use examples; then
		_PHASE="install samples" _lua_invoke_environment all _lua_src_install_examples
	fi
#### END  ####
}

#### TODO: move this things to more general eclass, like docs or so ####
_lua_src_install_examples() {
	debug-print-function $FUNCNAME "$@"

	local x

	pushd "${S}" >/dev/null

	if [[ "$(declare -p EXAMPLES 2>/dev/null 2>&1)" == "declare -a"* ]]; then
		for x in "${EXAMPLES[@]}"; do
			debug-print "$FUNCNAME: docs: creating examples from ${x}"
			docompress -x /usr/share/doc/${PF}/examples
			insinto /usr/share/doc/${PF}/examples
			if [[ "${x}" = *"/*" ]]; then
				pushd $(dirname ${x}) >/dev/null
				doins -r *
				popd >/dev/null
			else
				doins -r "${x}"
			fi || die "install examples failed"
		done
	fi

	popd >/dev/null
}
#### END ####

# @FUNCTION: dolua
# @USAGE: file [file...]
# @DESCRIPTION:
# Installs the specified file(s) into the proper INSTALL_?MOD location of the Lua interpreter in ${LUA}.
dolua() {
	local lmod=()
	local cmod=()
	for f in "$@"; do
		base_f="$(basename ${f})"
		case ${base_f} in
			*.lua|*.moon)
				lmod+=(${f})
				;;
			*.so)
				cmod+=(${f})
				;;
			*)
				if [[ -d ${f} ]]; then
					local insdir="${_dolua_insdir}/${base_f}"
					_dolua_insdir="${insdir}" dolua "${f}"/*
				else
					eerror "${f} is neither pure-lua module, nor moonscript library, nor C module, nor directory with them"
				fi
				;;
		esac
	done
	test -n "${lmod}" && _dolua_insdir="${_dolua_insdir}" dolua_lmod ${lmod[@]}
	test -n "${cmod}" && _dolua_insdir="${_dolua_insdir}" dolua_cmod ${cmod[@]}
}

dolua_lmod() {
	[[ -z ${LUA} ]] && die "\$LUA is not set"
	has "${EAPI}" 2 && ! use prefix && EPREFIX=
	local insdir="$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD ${lua_impl})"
	[[ -n "${_dolua_insdir}" ]] && insdir="${insdir}/${_dolua_insdir}"
	(
		insinto ${insdir#${EPREFIX}}
		insopts -m 0644
		doins -r "$@"
	) || die "failed to install $@"
}

dolua_cmod() {
	[[ -z ${LUA} ]] && die "\$LUA is not set"
	has "${EAPI}" 2 && ! use prefix && EPREFIX=
	local insdir="$($(tc-getPKG_CONFIG) --variable INSTALL_CMOD ${lua_impl})"
	[[ -n "${_dolua_insdir}" ]] && insdir="${insdir}/${_dolua_insdir}"
	(
		insinto ${insdir#${EPREFIX}}
		insopts -m 0644
		doins -r "$@"
	) || die "failed to install $@"
}

# @FUNCTION: lua_get_liblua
# @RETURN: The location of liblua*.so belonging to the Lua interpreter in ${LUA}.
lua_get_liblua() {
	local libdir="$($(tc-getPKG_CONFIG) --variable libdir ${lua_impl})"
	local libname="$($(tc-getPKG_CONFIG) --variable libname ${lua_impl})"
	libname="${libname:-lua$(lua_get_abi)}"
	echo "${libdir}/lib${libname}.so"
}

# @FUNCTION: lua_get_incdir
# @RETURN: The location of the header files belonging to the Lua interpreter in ${LUA}.
lua_get_incdir() {
	local incdir=$($(tc-getPKG_CONFIG) --variable includedir ${lua_impl})
	echo "${incdir}"
}

# @FUNCTION: lua_get_abi
# @RETURN: The version of the Lua interpreter ABI in ${LUA}, or what 'lua' points to.
lua_get_abi() {
	local lua=${LUA:-$(type -p lua 2>/dev/null)}
	[[ -x ${lua} ]] || die "Unable to locate executable Lua interpreter"
	echo $(${lua} -e 'print(_VERSION:match("[%d.]+"))')
}

# @FUNCTION: lua_get_implementation
# @RETURN: The implementation of the Lua interpreter in ${LUA}, or what 'lua' points to.
lua_get_implementation() {
	local lua=${LUA:-$(type -p lua 2>/dev/null)}
	[[ -x ${lua} ]] || die "Unable to locate executable Lua interpreter"

	case $(${lua} -v) in
		LuaJIT*)
			echo "luajit"
			;;
		*)
			echo "lua"
			;;
	esac
}

