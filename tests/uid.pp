# Set up a test user
user { 'jones':
  ensure  => present,
  uid     => 10034,
}

authbind::uid { '10034':
  ports   => {
    202 => '192.168.0.1',
    404 => '192.168.0.2/17',
  },
  require => User['jones'],
}
