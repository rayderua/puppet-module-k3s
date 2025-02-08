class k3s::install (

) inherits k3s {
  include archive
  $__k3s_url = "https://github.com/k3s-io/k3s/releases/download/${k3s::version}/k3s"

  if ( $k3s::ensure == 'present' ) {
    $__notify = [Service['k3s'], Exec['k3s-systemd-reload']]
  } else {
    $__notify = [Exec['k3s-systemd-reload']]
  }

  archive { '/usr/local/bin/k3s':
    ensure        => $k3s::ensure,
    source        => $__k3s_url,
    checksum      => $k3s::checksum,
    checksum_type => 'sha256',
    cleanup       => false,
    creates       => '/usr/local/bin/k3s',
    notify        => $__notify,
  }

  file { '/usr/local/bin/k3s':
    ensure  => $k3s::ensure,
    mode    => '0755',
    require => Archive['/usr/local/bin/k3s'],
    notify  => $__notify,
  }

  ['k3s-killall.sh', 'k3s-uninstall.sh'].each | String $__script | {
    file { "/usr/local/bin/${__script}":
      ensure  => 'file',
      mode    => '0755',
      source  => "puppet:///modules/${module_name}/${__script}",
      require => File['/usr/local/bin/k3s'],
    }
  }

  file { [
      '/etc/rancher',
      '/etc/rancher/k3s',
      '/etc/rancher/node',
      '/var/lib/rancher',
      '/var/lib/rancher/k3s',
      '/var/lib/rancher/k3s/server',
      '/var/lib/rancher/k3s/server/manifests',
    ]:
      ensure  => directory,
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      require => File['/etc/systemd/system/k3s.service'],
      notify  => $__notify,
  }

  if $k3s::manifests {
    each($k3s::manifests) | $__n, $__link | {
      archive { "/var/lib/rancher/k3s/server/manifests/${__n}.yaml":
        ensure  => 'present',
        source  => $__link,
        require => File['/var/lib/rancher/k3s/server/manifests'],
      }
    }
  }

  file { '/etc/systemd/system/k3s.service':
    ensure  => $k3s::ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('k3s/k3s.service.erb'),
    require => File['/usr/local/bin/k3s'],
    notify  => concat($__notify, Exec['k3s-systemd-reload']),
  }
}
