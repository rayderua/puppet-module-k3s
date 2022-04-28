class k3s (
  Enum['present','absent'] $ensure          = $::k3s::params::ensure,
  Enum['running','stopped'] $service_ensure = $::k3s::params::service_ensure,
  Boolean $service_enable                   = $::k3s::params::service_enable,
  Boolean $service_restart                  = $::k3s::params::service_restart,
  String  $version                          = $::k3s::params::version,
  String  $checksum                         = $::k3s::params::checksum,
) inherits k3s::params {

  contain k3s::install
  contain k3s::config
  contain k3s::service

  Class["k3s::install"]
  -> Class["k3s::config"]
  -> Class["k3s::service"]

}