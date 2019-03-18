file { '/etc/hosts':
        ensure => 'file',

        owner => 'root',

        group => 'root',

        mode => '0755',

        content => "
127.0.0.1 localhost
192.168.1.1   obelixmaas
192.168.1.149 master.obelix.com puppetsrv
# The following lines are desirable for IPv6 capable hosts
::1 ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
ff02::3 ip6-allhosts
"
}
