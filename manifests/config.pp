class k3s::config (

) inherits k3s {

  assert_private()


  $_envs = deep_merge($k3s::envs, { 'K3S_MODE' => $k3s::run_mode, 'K3S_ARGS' => $k3s::args.join(' ')} )

  file { "/etc/default/${::k3s::service_name}":
    ensure  => $k3s::ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    content => epp("${module_name}/default.epp", { 'envs' => $_envs }),
    notify  => $k3s::service_name,
  }

  file { "/etc/rancher/k3s/config.yaml":
    ensure  => $rke2::ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    content => epp("${module_name}/config.epp", { 'config' => $rke2::config }),
    notify  => $k3s::service_name,
  }

  ensure_resources ('rke2::manifest', $rke2::manifests)
}
