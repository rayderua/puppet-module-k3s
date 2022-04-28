class k3s::config (
  Array[String] $args = $::k3s::params::args,
  Hash $envs = $::k3s::params::envs,
) {
  file {'/etc/default/k3s':
    ensure    => present,
    content   => template('k3s/default.erb')
  }
}