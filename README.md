# pkg_inventory

#### Table of Contents

1. [Description](#description)
1. [Usage](#usage)
1. [Limitations](#limitations)

## Description

This module is exporting a structured fact hash ("packages") which contains all installed (RPM-) packages and their versions (including release and architecture).  
It includes packages which are installed as a dependency and not managed via Puppet directly.
As packages can be installed multiple times with different versions (e.g. "kernel"), the output is always an array with all installed versions.

It is intended to be used together with PuppetDB to provide a fast and reliable way to query all packages and versions in your infrastructure.


## Usage

You only need to install the module on your puppet server. With pluginsync enabled your nodes will automatically export the fact afterwards.  
There is no Puppet class you need to include.  
You can check if the facts are working correctly, e.g.:

```
# facter -p packages
{
  audit_libs => [
    "2.3.3-4.el7.x86_64"
  ],
  jansson => [
    "2.4-6.el7.x86_64"
  ],
  sed => [
    "4.2.2-5.el7.x86_64"
  ],
  kernel => [
    "3.10.0-123.el7.x86_64",
    "3.10.0-327.18.2.el7.x86_64"
  ],
  libdb => [
    "5.3.21-17.el7.x86_64"
  ],
  (...)
}
```

You can now query PuppetDB for these facts.  
E.g. "What version of yum is currently deployed on my servers?"

```
$ curl -s -X GET 'http://localhost:8080/pdb/query/v4/fact-contents?pretty=true' --data-urlencode 'query=["~>", "path", [ "packages", "yum", ".*" ]]'
[ {
  "certname" : "puppet",
  "path" : [ "packages", "yum", 0 ],
  "name" : "packages",
  "value" : "3.4.3-118.el7.centos.noarch",
  "environment" : "production"
}, {
  "certname" : "node1",
  "path" : [ "packages", "yum", 0 ],
  "name" : "packages",
  "value" : "3.4.3-118.el7.centos.noarch",
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

