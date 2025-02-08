## Puppet module
# k3s
#
# Init class k3s
#
# @param ensure
#   default present
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
  Enum['running','stopped'] $service_ensure,
  Boolean                   $service_enable,
  Boolean                   $service_restart,
  String                    $version,
  String                    $checksum,
  Array                     $args,
  Hash                      $envs,
  Hash                      $manifests,

) {
  contain k3s::install
  contain k3s::config
  contain k3s::service

  Class['k3s::install']
  -> Class['k3s::config']
  -> Class['k3s::service']
}
