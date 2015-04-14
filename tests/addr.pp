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

authbind::addr { '192.168.0.1':
  user    => 'jones',
  port    => 45,
  require => User['jones'],
}

authbind::addr { 'Allow jones to listen on the private network':
  user  => 'jones',
  group => 'testers',
  port  => '201',
  addr  => '192.168.0.1/24',
  require => User['jones'],
}
