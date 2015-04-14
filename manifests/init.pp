# == Class: authbind
#
# Manages the installation of Authbind.
#
# === Parameters
#
# [*version*]
#   The version of the authbind package to install.  Valid values are a
#   valid release (2.1.1 or 1.2.0) or latest. Defalut is latest.
#
# === Examples
#
# To install authbind_1.2.0:
#
#  class { 'authbind':
#    version => '1.2.0',
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
class authbind (
  $version = latest,
) {
  $_version = hiera_hash("${module_name}::version", $version)

  validate_re($_version, ['latest$', '^1.2.0$', '^2.1.1$',])

  anchor { 'authbind::start': }
  package { 'authbind':
    ensure  => $_version,
    require => Anchor['authbind::start'],
    before  => Anchor['authbind::installed'],
  }
  anchor { 'authbind::installed': }
}
