# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: This ebuild is from Lua overlay; Bumped by mva; $

EAPI="5"

inherit eutils multilib mercurial

DESCRIPTION="Add-on modules for Prosody IM Server written in Lua."
HOMEPAGE="https://modules.prosody.im/"
EHG_REPO_URI="https://hg.prosody.im/prosody-modules"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""

IUSE="misc luajit"

PROSODY_MODULES="
	addressing adhoc_account_management adhoc_blacklist admin_blocklist
	admin_message admin_probe admin_web alias auth_any auth_ccert
	auth_custom_http auth_dovecot auth_external auth_ha1 auth_http_async
	auth_imap auth_internal_yubikey auth_joomla auth_ldap auth_ldap2
	auth_pam auth_phpbb3 auth_sql auth_wordpress auto_accept_subscriptions
	auto_activate_hosts benchmark_storage bidi block_outgoing
	block_registrations block_s2s_subscriptions block_strangers
	block_subscribes block_subscriptions blocking broadcast
	c2s_conn_throttle c2s_limit_sessions candy captcha_registration carbons
	carbons_adhoc carbons_copies checkcerts client_certs cloud_notify
	compact_resource compat_bind compat_dialback compat_muc_admin
	compat_vcard component_client component_roundrobin
	conformance_restricted couchdb csi csi_compat data_access
	default_bookmarks default_vcard delegation disable_tls discoitems dwd
	email_pass extdisco fallback_vcard filter_chatstates firewall
	flash_policy group_bookmarks host_blacklist host_guard http_altconnect
	http_dir_listing http_favicon http_index http_logging http_muc_log
	http_upload http_user_count idlecompat incidents_handling inotify_reload
	ipcheck isolate_host jid_prep json_streams lastlog latex lib_ldap
	limit_auth limits list_inactive listusers log_auth log_events log_mark
	log_messages_sql log_rate log_sasl_mech log_slow_events mam mam_adhoc
	mam_archive mam_muc mamsub manifesto measure_cpu measure_memory
	message_logging migrate motd_sequential muc_access_control muc_ban_ip
	muc_config_restrict muc_intercom muc_limits muc_log muc_log_http
	muc_restrict_rooms munin net_dovecotauth offline_email onhold onions
	openid password_policy pastebin pep_vcard_avatar pinger poke_strangers
	post_msg presence_cache privacy_lists private_adhoc privilege proctitle
	profile proxy65_whitelist pubsub_eventsource pubsub_feeds pubsub_github
	pubsub_hub pubsub_mqtt pubsub_pivotaltracker pubsub_post pubsub_twitter
	query_client_ver rawdebug readonly register_json register_redirect
	register_web reload_modules remote_roster require_otr roster_allinall
	roster_command s2s_auth_compat s2s_auth_dane s2s_auth_fingerprint
	s2s_auth_monkeysphere s2s_blacklist s2s_idle_timeout s2s_keepalive
	s2s_keysize_policy s2s_log_certs s2s_never_encrypt_blacklist
	s2s_reload_newcomponent s2s_whitelist s2soutinjection saslauth_muc
	saslname seclabels secure_interfaces server_contact_info server_status
	service_directories sift smacks smacks_offline sms_clickatell
	srvinjection sslv3_warn stanza_counter statistics statistics_auth
	statistics_cputotal statistics_mem statistics_statsd statsd storage_gdbm
	storage_ldap storage_lmdb storage_memory storage_mongodb storage_muc_log
	storage_multi storage_xmlarchive streamstats strict_https
	support_contact swedishchef tcpproxy telnet_tlsinfo throttle_presence
	tls_policy turncredentials twitter uptime_presence vjud watchuntrusted
	webpresence
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
		virtual/lua[bit]
	)
	prosody_modules_couchdb? (
		dev-lua/luasocket
	)
	prosody_modules_auth_custom_http? (
		dev-lua/luasocket
	)
	prosody_modules_checkcerts? (
		dev-lua/luasec
	)
	prosody_modules_auth_internal_yubikey? (
		virtual/lua[bit,luajit=]
		dev-lua/yubikey-lua
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
	prosody_modules_log_messages_sql? (
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
			doins -r "mod_${m}"
		fi
	done
	use misc && (
		insinto /usr/lib/prosody/modules
		doins -r misc
	)
}
