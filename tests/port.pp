include authbind

# Set up a test group
group { 'testers':
  ensure => present,
}

# Set up a test user
user { 'jones':
  ensure  => present,
  gid     => 'testers',
  require => Group['testers'],
}

authbind::port { '56':
  user    => 'jones',
  require => User['jones'],
}

authbind::port { 'Allow jones to listen on 678':
  user  => 'jones',
  group => 'testers',
  port  => '678',
  require => User['jones'],
}
