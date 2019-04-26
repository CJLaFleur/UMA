file_line { '/etc/fstab':
        ensure => present,
        path => '/etc/fstab',
        line => "obelixmaas:/   /mnt   nfs4    _netdev,auto  0  0"
}
