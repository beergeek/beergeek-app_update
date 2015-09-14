# == Class: app_update
#
# Class to manage the `app_update` MCO agent and application
#
# === Parameters
#
# Document parameters here.
#
# [*agent*]
#   Boolean value to determine if the MCO agent is installed and managed.
#   A `false` value will remove the agent.
#   Default is `true`.
#
# [*application*]
#   Boolean value to determine if the MCO application is installed and managed.
#   A `false` value will remove the application.
#   Default is `false`.
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Examples
#
#  class { 'app_update':
#    agent       => true,
#    application => false,
#  }
#
# === Authors
#
# Brett Gray <brett.gray@puppetlabs.com>
#
# === Copyright
#
# Copyright 2015 Brett Gray
#
class app_update (
  $agent        = true,
  $application  = false,
) {

  validate_bool($agent)
  validate_bool($application)

  if $aio_agent_version {
    $mco_dir = '/opt/puppetlabs/mcollective/plugins/mcollective'
    $mco_svc = 'mcollective'
  }  else {
    $mco_dir = '/opt/puppet/libexec/mcollective/mcollective'
    $mco_svc = 'pe-mcollective'
  }

  File {
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
    notify => Service[$mco_svc],
  }


  file { 'app_update.ddl':
    ensure => file,
    path   => "${mco_dir}/agent/app_update.ddl",
    source => 'puppet:///modules/app_update/app_update.ddl',
  }

  if $agent {

  file { 'app_update.rb':
    ensure => file,
    path   => "${mco_dir}/agent/app_update.rb",
    source => 'puppet:///modules/app_update/app_update.rb',
  }

  }

  if $application {

  file { 'app_update_app.rb':
    ensure => file,
    path   => "${mco_dir}/application/app_update.rb",
    source => 'puppet:///modules/app_update/app_update_app.rb',
  }

  }

}
