case $facts['os']['name'] {
'Ubuntu':	{
$packages = [ 'nfs-common', 'ldap-auth-client', 'nscd', 'libnss-ldap', 'libpam-ldap', 'ldap-utils' ]

package { $packages:
  ensure => "installed"
        }
    }
'CentOS': {
$packages = [ 'openldap-clients', 'nss-pam-ldapd', 'nfs-utils' ]

package { $packages:
  ensure => "installed"
        }
  }
}
