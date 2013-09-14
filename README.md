startrek
========

Spencer Krum and William Van Hevelingen

This module demonstrates the use of data-in-modules from Puppet 3.3.0+

As described in [ARM-9](http://links.puppetlabs.com/arm9-data_in_modules)

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

```bash
cat data/common.yaml
```

```yaml
---
ops: spock
tactical: chekov
helm: sulu
communications: uhura
captain: kirk
starship:
  name: enterprise
  class: constitution
```

```bash
cat data/osfamily/Debian.yaml
```

```yaml
---
tactical: tuvok
ops: kim
helm: paris
engineering: torres
captain: janeway
starship:
  name: voyager
  class: intrepid
```

```bash
cat data/osfamily/RedHat.yaml
```

```yaml
---
tactical: worf
ops: data
helm: wesley
engineering: geordi
captain: picard
starship:
  name: enterprise
  class: galaxy
```

```bash
$ FACTER_OSFAMILY=Debian puppet apply tests/init.pp                                                                       
Notice: Compiled catalog for pro-puppet.lan in environment production in 0.23 seconds
Notice: janeway commands the voyager
Notice: /Stage[main]/Startrek/Notify[janeway commands the voyager]/message: defined 'message' as 'janeway commands the voyager'
Notice: Finished catalog run in 0.10 seconds

$ FACTER_osfamily=RedHat puppet apply tests/init.pp 
Notice: Compiled catalog for pro-puppet.lan in environment production in 0.23 seconds
Notice: picard commands the enterprise
Notice: /Stage[main]/Startrek/Notify[picard commands the enterprise]/message: defined 'message' as 'picard commands the enterprise'
Notice: Finished catalog run in 0.12 seconds

$ FACTER_osfamily=ArchLinux puppet apply tests/init.pp                                             
Notice: Compiled catalog for pro-puppet.lan in environment production in 0.23 seconds
Notice: kirk commands the enterprise
Notice: /Stage[main]/Startrek/Notify[kirk commands the enterprise]/message: defined 'message' as 'kirk commands the enterprise'
Notice: Finished catalog run in 0.11 seconds
```

License
-------

Apache 2

Contact
-------

Spencer Krum and William Van Hevelingen

Support
-------

Proof of concept, no support, not for production
