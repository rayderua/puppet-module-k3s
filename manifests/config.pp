class k3s::config (

) inherits k3s {
  file { '/etc/default/k3s':
    ensure  => file,
    content => template('k3s/default.erb'),
  }
}
