class k3s::service (

) inherits k3s {

  exec { 'k3s-systemd-reload':
    path        => ['/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/'],
    command     => 'systemctl daemon-reload > /dev/null',
    refreshonly => true,
  }

  service{"k3s":
    ensure  => $service_ensure,
    enable  => $service_enable,
    require => [
      Exec['k3s-systemd-reload'], File['/etc/systemd/system/k3s.service']
    ],
  }
}