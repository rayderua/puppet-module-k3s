class k3s::install (

) inherits k3s {

  assert_private()
  include archive

  $_download_url = "https://github.com/k3s-io/k3s/releases/download/${k3s::version}/k3s"

  if ( 'absent' == $k3s::ensure ) {
    if ( true == $purge ) {
      file { [
        '/usr/local/bin/k3s',
        '/etc/rancher/k3s',
        '/etc/rancher/node',
        '/var/lib/rancher/k3s',
        '/etc/profile.d/k3s.sh',
        "/etc/systemd/system/${k3s::service_name}.service"
      ]:
        ensure => $k3s::ensure,
        purge  => true,
        backup => false,
        force  => true,
      }

      ['k3s-killall.sh', 'k3s-uninstall.sh'].each | String $_script | {
        file { "/usr/local/bin/${_script}":
          ensure => $k3s::ensure,
          purge  => true,
          backup => false,
          force  => true,
        }
      }
    }
  } else {

    archive { '/usr/local/bin/k3s':
      ensure        => $k3s::ensure,
      source        => $_download_url,
      checksum      => $k3s::checksum,
      checksum_type => 'sha256',
      cleanup       => false,
      creates       => '/usr/local/bin/k3s',
      notify        => Service[$k3s::service_name],
    }

    file { '/usr/local/bin/k3s':
      ensure  => $k3s::ensure,
      mode    => '0755',
      require => Archive['/usr/local/bin/k3s'],
      notify  => Service[$k3s::service_name],
    }

    ['k3s-killall.sh', 'k3s-uninstall.sh'].each | String $_script | {
      file { "/usr/local/bin/${_script}":
        ensure => $k3s::ensure,
        mode   => '0755',
        source => "puppet:///modules/${module_name}/bin/${_script}",
      }
    }

    file { [
      '/etc/rancher',
      '/etc/rancher/k3s',
      '/etc/rancher/node',
      '/var/lib/rancher',
      '/var/lib/rancher/k3s',
      '/var/lib/rancher/k3s/server',
      '/var/lib/rancher/k3s/server/manifests'
    ]:
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
    }

    file { '/etc/profile.d/k3s.sh':
      ensure => $k3s::ensure,
      source => "puppet:///modules/${module_name}/etc/profile.sh",
    }

    file { "/etc/systemd/system/${k3s::service_name}.service":
      ensure  => $k3s::ensure,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => epp("${module_name}/k3s.service.epp"),
      require => File['/usr/local/bin/k3s'],
      notify  => [ Service[$k3s::service_name], Exec['k3s-systemd-reload'] ],
    }
  }
}
