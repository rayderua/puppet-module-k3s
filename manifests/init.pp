# @summary Install and manage k3s
#
# Install and manage k3s server/agent services
#
# @example
#   include k3s
#
# @param ensure
#   Ensure k3s service (present/absent)
# @param version
#   k3s version from https://github.com/k3s-io/k3s/releases
# @param checksum
#   k3s binary checksum from https://github.com/k3s-io/k3s/releases
# @param purge
#   Purge unmanaged resources (boolean)
# @param run_mode
#   Run mode (agent/server)
# @param envs
#   K3s daemon service environment variables (/etc/default/k3s)
# @param args
#   K3s daemon additional arguments
# @param config
#   K3s main config
# @param manifests
#   K3s additional manifests to deploy on cluster
# @param service_name
#   K3s system service name
# @param service_ensure
#   Service ensure running ot stopped
# @param service_enable
#   Service enable disable on startup
# @param service_restart
#   Restart service on config change or binary version upgrade

class k3s (
  Enum['present','absent']  $ensure,
  String                    $version,
  Variant[Undef,String]     $checksum,
  Boolean                   $purge,
  Enum['agent', 'server']   $run_mode,
  Hash                      $envs,
  Array                     $args,
  Hash                      $config,
  Hash                      $manifests,
  String                    $service_name,
  Enum['running','stopped'] $service_ensure,
  Boolean                   $service_enable,
  Boolean                   $service_restart,
) {

  $_service_notify = ( true == $service_restart ) ? {
    true    => Service[$service_name],
    default => undef
  }

  contain k3s::install
  contain k3s::config
  contain k3s::service

  Class['k3s::install']
  -> Class['k3s::config']
  -> Class['k3s::service']
}
