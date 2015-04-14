# == Resource: authbind::uid
#
# Configure authbind to allow a user access to restricted ports.
#
# === Parameters
#
# [*uid*]
#   User numerical ID authbind will grant access to. Defaults to `$name`.
#
# [*ports*]
#   Hash of port, address pairs authbind will grant the user access to.
#
# === Examples
#
# Grant the user with UID 1050 access to multiple ports at different
# addresses:
#
#  authbind::uid { '1050':
#    ports  => {
#      '80' => '123.46.64.2',
#      '55' => '192.168.0.0/17',
#    }
#  }
#
# === Authors
#
# Tyler Yahn <codingalias@moonshadowmobile.com>
#
# === Copyright
#
# Copyright 2015 Tyler Yahn
#
class authbind::uid (
  $uid   = $name,
  $ports = undef,
) {
  include authbind

  validate_integer($uid, undef, 0)
  validate_hash($ports)

  file { "/etc/authbind/byuid/${uid}":
    ensure  => file,
    owner   => $uid,
    mode    => '0700',
    content => template("${module_name}/uid.erb"),
    require => Anchor['authbind::installed'],
  }
}
