# == Class: app_update
#
# Full description of class app_update here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
#
# === Examples
#
#  class { 'app_update':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Author Name <author@domain.com>
#
# === Copyright
#
# Copyright 2015 Your name here, unless otherwise noted.
#
class app_update {

  if $::pe_version {
    $mco_svc = 'pe-mcollective'
  } else {
    $mco_svc = 'mcollective'
  }

  File {
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    notify => Service[$mco_svc],
  }

  $mco_dir = '/opt/puppet/libexec/mcollective/mcollective/agent'

  file { 'app_update.ddl':
    ensure => file,
    path   => "${mco_dir}/app_update.ddl",
    source => 'puppet:///modules/app_update/app_update.ddl',
  }

  file { 'app_update.rb':
    ensure => file,
    path   => "${mco_dir}/app_update.rb",
    source => 'puppet:///modules/app_update/app_update.rb',
  }

}
