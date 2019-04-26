class {'::easy_ipa':
ipa_role             => 'client',
domain               => 'cscf.edu',
domain_join_password => 'kRQBJ06T-8y09AL',
install_epel         => true,
ipa_master_fqdn      => 'obelixmgmt.cscf.edu',
}
