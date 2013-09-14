startrek by Spencer Krum and William Van Hevelingen

This is the startrek module. It is to demonstrate the use of data-in-modules from Puppet 3.3.

This README is more blog post than README and describes our process to get d-i-m working.


First verify that you have Puppet 3.3

Then turn on module bindings by adding the following to puppet.conf

```ini
parser = future
```

Put the following in your /etc/puppet/hiera.yaml

```yaml
---
version: 2
hierarchy:
  [ ['osfamily', '${osfamily}', '${osfamily}' ],
    ['environment', '${environment}', '${environment}' ],
    ['common', 'true', 'common' ]
  ]
backends:
  - yaml
  - json
```

Put the following in startrek/hiera.yaml, yes thats the hiera.yaml directly in your module root

```yaml
---
version: 2
```


Next create a test.pp file, if you used the puppet module tool you should already have this in tests/init.pp 

```puppet
include startrek
```

Create a datadir in your module:

```bash
cd startrek
mkdir data
cd data
```

    yoruichi:/etc/puppet/modules/startrek# cat data/common.yaml 
```yaml
    ---
    ops: spock
    tactical: chekov
    helm: sulu
    communications: uhura
    captain: kirk
```


License
-------

Apache 2

Contact
-------

Spencer Krum and William Van Hevelingen

Support
-------

Please log tickets and issues at github.
