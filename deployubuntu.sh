#!/bin/bash

sudo su

name=$(hostname)
fqdn=$(hostname -f)

hostnamectl set-hostname $fqdn

wget http://apt.puppetlabs.com/puppet-release-bionic.deb
dpkg -i puppet-release-bionic.deb
apt update -y

apt install puppet-agent -y

mv /etc/hosts /etc/hosts.default

echo "127.0.0.1 $fqdn $name localhost
192.168.245.2 obelixmaas.cscf.edu maas nfs
192.168.245.3 obelixmgmt.cscf.edu puppet ipa
::1 ip6-localhost ip6-loopback
fe00::0 ip6-localnet
ff00::0 ip6-mcastprefix
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
ff02::3 ip6-allhosts" >> /etc/hosts

mv /etc/puppetlabs/puppet/puppet.conf /etc/puppetlabs/puppet/puppet.conf.bk

echo "[main]
 certname = $fqdn
 server = obelixmgmt.cscf.edu
 environment = production
 runinterval = 15m" >> /etc/puppetlabs/puppet/puppet.conf

/opt/puppetlabs/bin/puppet resource service puppet ensure=running enable=true

/opt/puppetlabs/bin/puppet agent -t

reboot
