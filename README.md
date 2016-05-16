# pkg_inventory

#### Table of Contents

1. [Description](#description)
1. [Usage](#usage)
1. [Limitations](#limitations)

## Description

This module is exporting a structured fact hash ("packages") which contains all installed (RPM-) packages and their versions.  
This includes packages which are installed as a dependency and not managed via Puppet directly.

It is intended to be used together with PuppetDB to provide a fast and reliable way to query all packages and versions in your infrastructure.


## Usage

You only need to install the module on your puppet server. With pluginsync enabled your nodes will automatically export the fact afterwards.  
There is no Puppet class you need to include.  
You can check if the facts are working correctly, e.g.:

```
# facter -p packages
{
  dnsmasq => "2.66",
  filesystem => "3.2",
  libdrm => "2.4.50",
  kbd_misc => "1.15.5",
  (...)
}
```

You can now query PuppetDB for these facts.  
E.g. "What version of yum is currently deployed on my servers?"

```
$ curl -s -X GET 'http://localhost:8080/pdb/query/v4/fact-contents?pretty=true' --data-urlencode 'query=["=", "path", [ "packages", "yum" ]]'
[ {
  "certname" : "node1",
  "path" : [ "packages", "yum" ],
  "name" : "packages",
  "value" : "3.4.3",
  "environment" : "production"
}, {
  "certname" : "puppet",
  "path" : [ "packages", "yum" ],
  "name" : "packages",
  "value" : "3.4.3",
  "environment" : "production"
} ]
```


## Limitations

Installing this module will obviously export a large number of additional facts.
Depending on how many packages your systems have installed and how many systems you are running this may increase the size of your PuppetDB instance by a lot.  
Enable with caution.

Currently only Red Hat based systems are supported but it should be simple to adapt it to other operating systems as well.   

As this is exporting a structured fact you need to set [stringify_facts](https://docs.puppet.com/puppet/3.8/reference/configuration.html#stringifyfacts) to false when using Puppet 3.x.  
That is the default in Puppet 4.0.0 and greater.

