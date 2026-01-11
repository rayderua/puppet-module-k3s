# @summary Install and manage k3s
#
# Install and manage k3s server/agent services
#
# @example
#   include k3s
#
# @param ensure
#   Ensure k3s service (default: present)
# @param version
#   default v1.32.4+k3s1
# @param service_ensure
#   default running
# @param service_enable
#   default true
# @param service_restart
#   default false
# @param version
#   default v1.31.4+k3s1
# @param checksum
#   default 74897e4af26ea383ce50f445752f40ca63a0aef0d90994fb74073c43063eeeb2
# @param args
# @param envs
# @param manifests
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

  if ( 'present' == $k3s::ensure ) {
    $_notify = [ Service[$k3s::service_name] ]
  } else {
    $_notify = [ undef ]
  }

  contain k3s::install
  contain k3s::config
  contain k3s::service

  Class['k3s::install']
  -> Class['k3s::config']
  -> Class['k3s::service']

}
