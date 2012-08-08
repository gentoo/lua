# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="4"

inherit eutils multilib mercurial

DESCRIPTION="Add-on modules for Prosody IM Server written in Lua."
HOMEPAGE="http://prosody-modules.googlecode.com/"
EHG_REPO_URI="https://prosody-modules.googlecode.com/hg/"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
PROSODY_MODULES="
	addressing admin_web archive archive_muc auth_dovecot auth_external
	auth_internal_yubikey auth_joomla auth_ldap auth_phpbb3 auth_sql auth_wordpress
	auto_accept_subscriptions blocking block_s2s_subscriptions block_strangers
	block_subscriptions broadcast c2s_conn_throttle carbons checkcerts client_certs
	compat_bind compat_muc_admin compat_vcard component_roundrobin conformance_restricted
	couchdb	data_access default_bookmarks default_vcard discoitems extdisco flash_policy
	group_bookmarks host_guard http_favicon inotify_reload ipcheck json_streams
	lastlog latex limits log_auth mam mam_adhoc motd_sequential muc_intercom muc_limits
	muc_log muc_log_http offline_email onhold openid pastebin post_msg pubsub_feeds
	pubsub_hub readonly register_json register_redirect register_web reload_modules
	remote_roster roster_command s2s_idle_timeout s2s_never_encrypt_blacklist
	s2s_reload_newcomponent saslauth_muc seclabels server_contact_info server_status
	service_directories sift smacks sms_clickatell srvinjection stanza_counter
	storage_mongodb streamstats support_contact swedishchef tcpproxy throttle_presence
	twitter vjud webpresence websocket
"


for x in ${PROSODY_MODULES}; do
        IUSE="${IUSE} ${x//[^+]/}prosody_modules_${x/+}"
done


DEPEND="net-im/prosody"
#	ircd? ( dev-lua/squish dev-lua/verse )"
RDEPEND="${DEPEND}"

src_install() {
	cd "${S}";
	for m in ${PROSODY_MODULES}; do
		if use prosody_modules_${m}; then
			insinto /usr/lib/prosody/modules;
			doins -r "mod_${m}" || die
		fi
	done
}

#pkg_postinst() {
#	if use ircd; then
#		cd /usr/lib/prosody/modules/mod_ircd;
#		cp "$(pkg-config --variable INSTALL_LMOD lua)"/verse.lua verse.lua
#		squish --use-http
#	fi
#}
