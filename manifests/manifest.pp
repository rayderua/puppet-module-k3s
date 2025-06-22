# @summary A short summary of the purpose of this defined type.
#
# A description of what this defined type does
#
#   @example
#   k3s::manifest { 'argocd':
#     link => https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
#   }
#   @param ensure
#   Specifies whether the manifest should exist.
#
#   @param source
#   Specifies source for manifest file
#
#   @param content
#   Specifies content of manifests
#
#   @param config
#   Specifies Hash or Array[Hash] of manifest. Will generate manifest via to_yaml puppet functions
#
#   @param link
#   Specifies link for download manifest. Manifest will иу downloaded via archive module
#
#   @param link_checksum
#   Specifies checksum for archive module
#
#   @param link_checksum_type
#   Specifies checksum_tyoe for archive module
#

define k3s::manifest (
  Enum['present','absent'] $ensure               = 'present',
  Variant[Undef, String] $source                 = undef,
  Variant[Undef, String] $content                = undef,
  Variant[Undef, Hash, Array[Hash]] $config      = undef,
  Variant[Undef, String] $link                   = undef,
  Variant[Undef, String] $link_checksum          = undef,
  Variant[Undef, String] $link_checksum_type     = undef,
) {
  $_sources = delete_undef_values(
    [$source, $content, $config, $link].reduce([]) | $memo, $data | {
      if ( undef == $data ) {
        concat( $memo, [])
      } else {
        concat( $memo, [$data])
      }
    }
  )

  if ( 0 == size($_sources) ) {
    fail("One of 'source', 'content', 'config', 'link' is required")
  } elsif ( 1 != size($_sources) ) {
    fail("Parameters 'source', 'content', 'config', 'link' are mutually exclusive")
  }

  if ( 'absent' == $k3s::ensure  or 'absent' == $ensure ) {
    $_ensure = 'absent'
  } else {
    $_ensure = 'present'
  }

  $_manifest_path = "/var/lib/rancher/k3s/server/manifests/${name}.yaml"
  if ( undef != $link ) {
    archive { "k3s-manifest-${name}":
      ensure        => $_ensure,
      path          => $_manifest_path,
      source        => $link,
      cleanup       => false,
      creates       => $_manifest_path,
      checksum      => $link_checksum,
      checksum_type => $link_checksum_type,
    }
  } else {
    if ( undef == $source ) {
      file { "k3s-manifest-${name}":
        ensure  => $_ensure,
        path    => $_manifest_path,
        content => epp("${module_name}/manifest.epp", { 'config' => $config, 'content' => $content, 'name' => $name }),
      }
    } else {
      file { "k3s-manifest-${name}":
        ensure  => $_ensure,
        path    => $_manifest_path,
        source  => $source,
      }
    }
  }
}
