class k3s::service {

  exec { 'k3s-systemd-reload':
    path        => ['/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/'],
    command     => 'systemctl daemon-reload > /dev/null',
    refreshonly => true,
  }

  service{"k3s.service":
    ensure  => $service_ensure,
    enable  => $service_ensure,
    require => [
      Exec['k3s-systemd-reload'], File['/etc/systemd/system/k3s.service']
    ],
  }
}