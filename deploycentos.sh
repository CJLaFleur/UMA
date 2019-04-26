#!/bin/bash

sudo su

name=$(hostname)
fqdn=$(hostname -f)

hostnamectl set-hostname $fqdn

rpm -Uvh https://yum.puppet.com/puppet6/puppet6-release-el-7.noarch.rpm

yum update -y
yum install -y nano
yum install -y puppet-agent

mv /etc/hosts /etc/hosts.default
echo "127.0.0.1 $fqdn $name localhost localhost.localdomain localhost4 localhost4.localdomain4
192.168.245.2 obelixmaas.cscf.edu maas nfs
192.168.245.3 obelixmgmt.cscf.edu puppet ipa
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6" >> /etc/hosts

mv /etc/puppetlabs/puppet/puppet.conf /etc/puppetlabs/puppet/puppet.conf.default

echo "[main]
 certname = $fqdn
 server = obelixmgmt.cscf.edu
 environment = production
 runinterval = 15m" >> /etc/puppetlabs/puppet/puppet.conf

/opt/puppetlabs/bin/puppet resource service puppet ensure=running enable=true

/opt/puppetlabs/bin/puppet agent -t

reboot
