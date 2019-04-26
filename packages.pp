case $facts['os']['name'] {
'Ubuntu':	{
$packages = [ 'nfs-common' ]
package { $packages:
  ensure => "installed"
        }
    }
'CentOS': {
$packages = [ 'nfs-utils' ]
package { $packages:
  ensure => "installed"
        }
  }
}
