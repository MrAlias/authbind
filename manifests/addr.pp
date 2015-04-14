# == Resource: authbind::addr
#
# Configure authbind to allow a user and group access a restricted port for
# an address range.
#
# === Parameters
#
# [*user*]
#   User authbind will grant access to.
#
# [*group*]
#   Group members of which authbind will grant access to.
#
# [*port*]
#   Port or range of ports authbind will grant access to. Required parameter.
#
# [*addr*]
#   Valid IPV4 or IPV6 address or CIDR address range authbind will grant
#   access to. Defaults to `$name`.
#
# === Examples
#
# Grant the user butters listen on port 80 through 90 to the private network:
#
#  authbind::addr { '192.168.0.1/24':
#    user => 'butters',
#    port => '80-90',
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
class authbind::addr (
  $addr  = $name,
  $port  = undef,
  $user  = undef,
  $group = undef,
) {
  include authbind

  validate_string($port, $addr)

  if user {
    validate_string($user)
    if $group {
      validate_string($group)
      File {
        mode  => '0770',
      }
    } else {
      File {
        mode => '0700'
      }
    }
  } elsif $group {
    File {
      mode  => '0070',
    }
  } else {
    fail('No user or group given.')
  }

  file { "/etc/authbind/byaddr/${addr},${port}":
    ensure  => file,
    owner   => $user,
    group   => $group,
    require => Anchor['authbind::installed'],
  }
}
