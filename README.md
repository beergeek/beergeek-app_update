# app_update

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with app_update](#setup)
    * [What app_update affects](#what-app_update-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with app_update](#beginning-with-app_update)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

A module to manage an MCollective Agent and Application to perform Application Code Base Updates.
This is demonstration code.

## Module Description

Manages MCollective Agent and Application.
The MCO Agent should be utilised on any application server.
The MCO Application should be on the build server, such as Bamboo or Artifactory.

## Setup

### What app_update affects

Manages the MCO Agent and Application; restarts the MCollective service as required.

### Setup Requirements

Does not use pluginsync as we do not want all nodes to have these agents or applications.

### Beginning with app_update

By default the MCO Agent is managed and not the MCO application.

For PE, create a Node Group in the Classifier and assign the `app_update` class.
A further Node Group maybe created for the build server, and this should also be assigned the 
`app_update` class, but the `application` parameter should be `true` and the `agent` parameter
should be `false`.

NOTE: If the `agent` and `application` parameters are `false` the agents, applications and DDL files will be removed.

Alternatively: 
```puppet
    # for application servers
    class { 'app_update':
      application => false,
      agent       => true,
    }

    # for build servers
    class { 'app_update':
      application => true,
      agent       => false,
    }
```

## Usage

## Reference

### Classes

#### app_update

##### `agent`
Boolean value to determine if the MCO agent is installed and managed.
A `false` value will remove the agent.
Default is `true`.

##### `application`
Boolean value to determine if the MCO application is installed and managed.
A `false` value will remove the application.
Default is `false`.

## MCO Usage

As the correct user (peadmin or dashbaord on PE) issue the following command:
```puppet
    mco app_update --service NAME_OF_SERVICE --app NAME_OF_APP_PACKAGE --app_version VERSION_OF_APP_PACKAGE

    or
    mco app_update --s NAME_OF_SERVICE -a NAME_OF_APP_PACKAGE -p VERSION_OF_APP_PACKAGE

    # Example
    mco app_update -s httpd -a website_code_base -p 1.0.0-1 -v -F pp_role=web_server
```

```puppet
  mco app_update --help

  Update code base for an application
  Application Options
      -s, --service SERVICE            Service to stop and start
      -a, --application APPLICATION    Name of the application to update code base
      -p, --app_version VERSION        Version to upgrade to, use semver or 'latest'
```

Note this is demonstration code.  It will perform the following on the node:
* Disable Puppet
* Stop the desired service
* Download the package
* Start the service
* Enable Puppet

## Limitations

Used and tested on CentOS/RHEL6

## Development

## Release Notes/Contributors/Etc

