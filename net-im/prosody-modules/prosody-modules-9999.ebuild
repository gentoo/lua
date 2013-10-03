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
	addressing adhoc_account_management admin_web auth_ccert
	auth_custom_http auth_dovecot auth_external auth_imap
	auth_internal_yubikey auth_joomla auth_ldap auth_ldap2 auth_pam
	auth_phpbb3 auth_sql auth_wordpress auto_accept_subscriptions
	auto_activate_hosts bidi blocking block_registrations
	block_s2s_subscriptions block_strangers block_subscribes
	block_subscriptions broadcast c2s_conn_throttle candy carbons
	carbons_adhoc carbons_copies checkcerts client_certs compat_bind
	compat_muc_admin compat_vcard component_client
	component_roundrobin conformance_restricted couchdb data_access
	default_bookmarks default_vcard discoitems dwd extdisco firewall
	flash_policy group_bookmarks host_blacklist host_guard
	http_dir_listing http_favicon incidents_handling inotify_reload
	ipcheck isolate_host jid_prep json_streams lastlog latex lib_ldap
	limits listusers log_auth log_messages_sql mam mam_adhoc mam_muc
	mam_muc_sql mam_sql message_logging motd_sequential muc_ban_ip
	muc_config_restrict muc_intercom muc_limits muc_log muc_log_http
	net_dovecotauth offline_email onhold onions openid password_policy
	pastebin post_msg pubsub_eventsource pubsub_feeds pubsub_github
	pubsub_googlecode pubsub_hub pubsub_pivotaltracker pubsub_twitter
	readonly register_json register_redirect register_web
	reload_modules remote_roster roster_command s2s_auth_compat
	s2s_auth_dnssec_srv s2s_auth_fingerprint s2s_blacklist
	s2s_idle_timeout s2s_keepalive s2s_keysize_policy s2s_log_certs
	s2s_never_encrypt_blacklist s2soutinjection
	s2s_reload_newcomponent saslauth_muc seclabels secure_interfaces
	server_contact_info server_status service_directories sift smacks
	sms_clickatell srvinjection stanza_counter statistics storage_ldap
	storage_mongodb streamstats strict_https support_contact
	swedishchef tcpproxy telnet_tlsinfo throttle_presence
	turncredentials twitter uptime_presence vjud watchuntrusted
	webpresence websocket
"


for x in ${PROSODY_MODULES}; do
	IUSE="${IUSE} ${x//[^+]/}prosody_modules_${x/+}"
done


DEPEND="=net-im/prosody-${PV}"
RDEPEND="
	${DEPEND}
	prosody_modules_inotify_reload? (
		dev-lua/linotify
	)
	prosody_modules_auth_joomla? (
		dev-lua/luadbi
	)
	prosody_modules_lib_ldap? (
		dev-lua/lualdap
	)
	prosody_modules_client_certs? (
		dev-lua/luasec
	)
	prosody_modules_listusers? (
		dev-lua/luasocket
		dev-lua/luafilesystem
	)
	prosody_modules_pubsub_pivotaltracker? (
		dev-lua/luaexpat
	)
	prosody_modules_auth_phpbb3? (
		dev-lua/luadbi
	)
	prosody_modules_log_messages_sql? (
		dev-lua/luadbi
	)
	prosody_modules_message_logging? (
		dev-lua/luafilesystem
	)
	prosody_modules_onions? (
		|| (
			>=dev-lang/lua-5.2
			dev-lang/luajit:2
			dev-lua/LuaBitOp
		)
	)
	prosody_modules_couchdb? (
		dev-lua/luasocket
	)
	prosody_modules_auth_custom_http? (
		dev-lua/luasocket
	)
	prosody_modules_mam_muc_sql? (
		dev-lua/luasocket
		dev-lua/luadbi
	)
	prosody_modules_checkcerts? (
		dev-lua/luasec
	)
	prosody_modules_auth_internal_yubikey? (
		|| (
			>=dev-lang/lua-5.2
			dev-lang/luajit:2
			dev-lua/LuaBitOp
		)
		dev-lua/yubikey-lua
	)
	prosody_modules_websocket? (
		|| (
			>=dev-lang/lua-5.2
			dev-lang/luajit:2
			dev-lua/LuaBitOp
		)
	)
	prosody_modules_auth_dovecot? (
		dev-lua/luasocket
	)
	prosody_modules_storage_ldap? (
		dev-lua/luasocket
	)
	prosody_modules_statistics? (
		dev-lua/luaposix[ncurses]
	)
	prosody_modules_http_dir_listing? (
		dev-lua/luasocket
		dev-lua/luafilesystem
	)
	prosody_modules_mam_sql? (
		dev-lua/luasocket
		dev-lua/luadbi
	)
	prosody_modules_storage_mongodb? (
		dev-lua/luamongo
	)
	prosody_modules_offline_email? (
		dev-lua/luasocket
	)
	prosody_modules_auth_wordpress? (
		dev-lua/luadbi
	)
	prosody_modules_muc_log_http? (
		dev-lua/luafilesystem
		dev-lua/luaexpat
	)
	prosody_modules_component_client? (
		dev-lua/luasocket
	)
	prosody_modules_auth_external? (
		dev-lua/lpc
	)
	prosody_modules_auth_sql? (
		dev-lua/luadbi
	)
"

REQUIRED_USE="
	prosody_modules_auth_ldap? ( prosody_modules_lib_ldap )
	prosody_modules_auth_ldap2? ( prosody_modules_lib_ldap )
"

src_install() {
	cd "${S}";
	for m in ${PROSODY_MODULES}; do
		if use prosody_modules_${m}; then
			insinto /usr/lib/prosody/modules;
			doins -r "mod_${m}" || die
		fi
	done
}
