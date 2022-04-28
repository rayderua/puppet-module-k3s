class k3s::params {
  $ensure           = 'present'
  $service_ensure   = 'running'
  $service_enable   = true
  $service_restart  = false
  $version  = "1.23.5"
  $checksum = "e2b86b5a3ad2f90cf2218ad39cbc5c825dd329cf761e34929dc4c7267996d329"

  $args_prefix = "--"
  $args = [
    '--no-deploy "traefik"',
    '--docker',
    '--kubelet-arg "cgroup-driver=systemd"',
  ]
  $envs = { }
}