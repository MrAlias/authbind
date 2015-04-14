# == Resource: authbind::port
#
# Configure authbind to allow a user and group access a restricted port.
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
#   Port authbind will grant access to.  Defaluts to `$name`.
#
# === Examples
#
# Grant the user frank and anyone in the group dev access to port 33:
#
#  authbind::port { '33':
#    user  => 'frank',
#    group => 'dev',
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
class authbind::port (
  $port  = $name,
  $user  = undef,
  $group = undef,
) {
  include authbind

  validate_integer($port, undef, 0)

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
    fail("Did not get a user or group to grant access to port ${port} to.")
  }

  file { "/etc/authbind/byport/${port}":
    ensure  => file,
    owner   => $user,
    group   => $group,
    require => Anchor['authbind::installed'],
  }
}
