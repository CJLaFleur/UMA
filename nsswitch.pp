file { '/etc/nsswitch.conf':

        ensure => 'file',

        owner => 'root',

        group => 'root',

        mode => '0755',

        content => "

# /etc/nsswitch.conf

#

# Example configuration of GNU Name Service Switch functionality.

# If you have the glibc-doc-reference and info packages installed, try:

# info libc Name Service Switch for information about this file.



passwd:         compat systemd ldap sss

group:          compat systemd ldap sss

shadow:         compat sss

gshadow:        files



hosts:          files mdns4_minimal [NOTFOUND=return] dns myhostname

networks:	files



protocols:	db files

services:	db files sss

ethers:         db files

rpc:            db files



netgroup:	nis sss

sudoers: files sss

"
}
