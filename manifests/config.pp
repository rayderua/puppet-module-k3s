class k3s::config (
  $args = $::k3s::params::args,
  $args_prefix = $::k3s::params::args_prefix,
  $envs = $::k3s::params::envs,
) {
  file {'/etc/default/k3s':
    ensure    => present,
    content   => template('k4s/default.erb')
  }
}