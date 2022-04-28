class k3s::install (

) inherits k3s {

  include archive
  $k3s_url = "https://github.com/k3s-io/k3s/releases/download/v${k3s::version}+k3s/k3s"

  if ( $k3s::ensure == 'present' ) {
    $notify = [ Service['k3s'], Exec['k3s-systemd-reload'] ]
  } else {
    $notify = [ Exec['k3s-systemd-reload'] ]
  }

  archive { '/usr/local/bin/k3s':
    ensure        => $k3s::ensure,
    source        => $k3s_url,
    checksum      => $checksum,
    checksum_type => 'sha256',
    cleanup       => false,
    creates       => '/usr/local/bin/k3s',
    notify        => $notify,
  }

  file { '/usr/local/bin/k3s':
    ensure  => $k3s::ensure,
    mode    => '0755',
    require => Archive['/usr/local/bin/k3s'],
    notify  => $notify,
  }

  file { [
    '/etc/rancher',
    '/etc/rancher/k3s',
    '/etc/rancher/node',
    '/var/lib/rancher',
    '/var/lib/rancher/k3s',
  ]:
    ensure  => directory,
    owner   => 'root', group => 'root', mode => '0755',
    require => File['/etc/systemd/system/k3s.service'],
    notify  => $notify,
  }

  file { "/etc/systemd/system/k3s.service":
    ensure  => $k3s::ensure,
    owner   => 'root', group => 'root', mode => '0644',
    source  => "puppet:///modules/${module_name}/k3s.service",
    require => File['/usr/local/bin/k3s'],
    notify  => $notify,
  }

}