class k3s::service (

) inherits k3s {

  exec { 'k3s-systemd-reload':
    path        => ['/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/'],
    command     => 'systemctl daemon-reload > /dev/null',
    refreshonly => true,
  }

  if ( 'present' == $k3s::ensure ) {
    service { $k3s::service_name:
      ensure  => $k3s::service_ensure,
      enable  => $k3s::service_enable,
      require => [
        Exec['k3s-systemd-reload'],
        File['/etc/systemd/system/k3s.service']
      ]
    }
  } else {
    service { $k3s::service_name:
      ensure => stopped,
      enable => false,
    }
  }
}
