#!/bin/bash
sudo su
name=$(hostname | cut -f1 -d '.')

ssh centos@192.168.1.149 "/opt/puppetlabs/bin/puppet cert clean $name"

rpm -Uvh https://yum.puppetlabs.com/puppet5/puppet5-release-el-7.noarch.rpm
yum update -y
yum install -y nano
yum install -y puppet-agent

mv /etc/hosts /etc/hosts.bk
echo "127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
192.168.1.149 master.obelix.com puppetsrv
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6" >> /etc/hosts

mv /etc/puppetlabs/puppet/puppet.conf /etc/puppetlabs/puppet/puppet.conf.bk

echo "[main]
 certname = $name
 server = master.obelix.com
 environment = production
 runinterval = 15m" >> /etc/puppetlabs/puppet/puppet.conf

/opt/puppetlabs/bin/puppet resource service puppet ensure=running enable=true

/opt/puppetlabs/bin/puppet agent -t

reboot
