<?php
$CONFIG = array (
   'openid-connect' => [
    'provider-url' => 'https://$EDS_CONTAINER_PREFIX-keycloak:8443/realms/royaume',
    'client-id' => 'keycloak',
    'client-secret' => '$KEYCLOAK_CLIENT_SECRET',
    'loginButtonName' => 'Keycloak',
    'post_logout_redirect_uri' => 'https://drive.$EDS_DOMAIN/index.php/apps/openidconnect/redirect',
    'provider-params' => [
      'authorization_endpoint' => 'https://keycloak.$EDS_DOMAIN/realms/royaume/protocol/openid-connect/auth',
      'token_endpoint' => 'https://$EDS_CONTAINER_PREFIX-keycloak:8443/realms/royaume/protocol/openid-connect/token',
      'token_endpoint_auth_methods_supported' => ["private_key_jwt", "client_secret_basic", "client_secret_post", "tls_client_auth", "client_secret_jwt"],
      'userinfo_endpoint' => 'https://$EDS_CONTAINER_PREFIX-keycloak:8443/realms/royaume/protocol/openid-connect/userinfo',
      'registration_endpoint' => 'https://$EDS_CONTAINER_PREFIX-keycloak:8443/realms/royaume/clients-registrations/openid-connect',
      'end_session_endpoint' => 'https://keycloak.$EDS_DOMAIN/realms/royaume/protocol/openid-connect/logout&client_id=keycloak',
      'jwks_uri' => 'https://$EDS_CONTAINER_PREFIX-keycloak:8443/realms/royaume/protocol/openid-connect/certs',
    ],
    'auto-provision' => [
      // explicit enable the auto provisioning mode
      'enabled' => true,
      // documentation about standard claims: https://openid.net/specs/openid-connect-core-1_0.html#StandardClaims
      // only relevant in userid mode,  defines the claim which holds the email of the user
      'email-claim' => 'email',
      // defines the claim which holds the display name of the user
      'display-name-claim' => 'preferred_name',
      // defines the claim which holds the picture of the user - must be a URL
      'picture-claim' => 'picture',
      // defines a list of groups to which the newly created user will be added automatically
      'groups' => ['admin', 'guests'],
    ],
  ],
  'apps_paths' => 
  array (
    0 => 
    array (
      'path' => '/var/www/owncloud/apps',
      'url' => '/apps',
      'writable' => false,
    ),
    1 => 
    array (
      'path' => '/var/www/owncloud/custom',
      'url' => '/custom',
      'writable' => true,
    ),
  ),
  'trusted_domains' => 
  array (
    0 => 'drive.$EDS_DOMAIN',
  ),
  'datadirectory' => '/mnt/data/files',
  'dbtype' => 'mysql',
  'dbhost' => '$EDS_CONTAINER_PREFIX-owncloud-mysql:3306',
  'dbname' => 'owncloud',
  'dbuser' => 'owncloud',
  'dbpassword' => '$OWNCLOUD_DB_USER_PASSWORD',
  'dbtableprefix' => 'oc_',
  'log_type' => 'owncloud',
  'supportedDatabases' => 
  array (
    0 => 'sqlite',
    1 => 'mysql',
    2 => 'pgsql',
  ),
  'upgrade.disable-web' => true,
  'default_language' => 'fr',
  'overwrite.cli.url' => 'http://drive.$EDS_DOMAIN/',
  'htaccess.RewriteBase' => '/',
  'logfile' => '/mnt/data/files/owncloud.log',
  'memcache.local' => '\\OC\\Memcache\\APCu',
  'mysql.utf8mb4' => true,
  'filelocking.enabled' => true,
  'memcache.distributed' => '\\OC\\Memcache\\Redis',
  'memcache.locking' => '\\OC\\Memcache\\Redis',
  'redis' => 
  array (
    'host' => '$EDS_CONTAINER_PREFIX-owncloud-redis',
    'port' => '6379',
  ),
  'passwordsalt' => '$OWNCLOUD_SALT',
  'secret' => '$OWNCLOUD_SECRET',
  'version' => '10.14.0.3',
  'allow_user_to_change_mail_address' => '',
  'logtimezone' => 'UTC',
  'installed' => false,
  'instanceid' => 'oc6eewhjhe68',
  'loglevel' => 0,
);
