# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit eutils multilib mercurial

DESCRIPTION="Add-on modules for Prosody IM Server written in Lua."
HOMEPAGE="http://prosody-modules.googlecode.com/"
EHG_REPO_URI="https://prosody-modules.googlecode.com/hg/"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
PROSODY_MODULES="
	addressing admin_web auth_dovecot auth_external auth_internal_yubikey
	auth_joomla auth_ldap auth_ldap2 auth_phpbb3 auth_sql auth_wordpress
	auto_accept_subscriptions auto_activate_hosts bidi blocking
	block_s2s_subscriptions block_strangers block_subscribes
	block_subscriptions broadcast c2s_conn_throttle candy carbons
	carbons_adhoc carbons_copies checkcerts client_certs compat_bind
	compat_muc_admin compat_vcard component_client component_roundrobin
	conformance_restricted couchdb data_access default_bookmarks default_vcard
	discoitems dwd extdisco firewall flash_policy group_bookmarks host_guard
	http_dir_listing http_favicon incidents_handling inotify_reload ipcheck
	isolate_host jid_prep json_streams lastlog last_offline latex lib_ldap
	limits log_auth log_messages_sql mam mam_adhoc mam_muc mam_muc_sql mam_sql
	message_logging motd_sequential muc_ban_ip muc_config_restrict
	muc_intercom muc_limits muc_log muc_log_http offline_email onhold openid
	password_policy pastebin post_msg pubsub_eventsource pubsub_feeds
	pubsub_github pubsub_googlecode pubsub_hub pubsub_pivotaltracker
	pubsub_twitter readonly register_json register_redirect register_web
	reload_modules remote_roster roster_command s2s_auth_compat
	s2s_auth_dnssec_srv s2s_auth_fingerprint s2s_idle_timeout s2s_log_certs
	s2s_never_encrypt_blacklist s2s_reload_newcomponent saslauth_muc seclabels
	server_contact_info server_status service_directories sift smacks
	sms_clickatell srvinjection stanza_counter storage_ldap storage_mongodb
	streamstats strict_https support_contact swedishchef tcpproxy
	throttle_presence twitter uptime_presence vjud webpresence websocket
"


for x in ${PROSODY_MODULES}; do
        IUSE="${IUSE} ${x//[^+]/}prosody_modules_${x/+}"
done


DEPEND="=net-im/prosody-${PV}"
RDEPEND="${DEPEND}
prosody_modules_inotify_reload? ( dev-lua/linotify )"

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
#		cp "$($(tc-getPKG_CONFIG) --variable INSTALL_LMOD lua)"/verse.lua verse.lua
#		squish --use-http
#	fi
#}
