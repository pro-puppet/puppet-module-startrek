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

Going Further
=============

Now we want to use a custom category (remember that categories are the new word for hierarchies). 

We're going to use species. Now we need a binder_config.yaml in /etc/puppet:

```yaml
---
version: 1
layers:
  [{name: site, include: 'confdir-hiera:/'},
   {name: modules, include: ['module-hiera:/*/', 'module:/*::default'] }
  ]
categories:
  [['node', '${fqdn}'],
   ['environment', '${environment}'],
   ['species', '${species}'],
   ['osfamily', '${osfamily}'],
   ['common', 'true']
  ]
```


Notice that we've added species to the category list. Your system doesn't ship with a binder_config.yaml by default so you will probably have to make one.


Next lets modify the hiera.yaml in our moduleroot:

```yaml
---
version: 2
hierarchy:
  [['osfamily', '$osfamily', 'data/osfamily/$osfamily'],
   ['species', '$species', 'data/species/$species'],
   ['environment', '$environment', 'data/env/$environment'],
   ['common', 'true', 'data/common']
  ]
```

Lets also create some data and add some notifies to our manifests:

```bash
root@hiera-2:/etc/puppet/modules/startrek# cat data/species/human.yaml 
---
species: human
secret_group: 'section 31'
root@hiera-2:/etc/puppet/modules/startrek# cat data/species/romulan.yaml 
---
species: romulan
secret_group: 'tal shiar'
root@hiera-2:/etc/puppet/modules/startrek# cat data/species/cardassian.yaml 
---
species: cardassian
secret_group: 'obsidian order
```

And add the following to init.pp

```puppet
...

   $secret_group = lookup('secret_group')

   notify {"${captain} is always wary of the ${secret_group}": }
...

```

And finally the test:


```bash
root@hiera-2:/etc/puppet/modules/startrek# FACTER_species=human puppet apply tests/init.pp 
Notice: Compiled catalog for hiera-2.green.gah in environment production in 1.08 seconds
Notice: janeway commands the voyager
Notice: /Stage[main]/Startrek/Notify[janeway commands the voyager]/message: defined 'message' as 'janeway commands the voyager'
Notice: janeway is always wary of the section 31
Notice: /Stage[main]/Startrek/Notify[janeway is always wary of the section 31]/message: defined 'message' as 'janeway is always wary of the section 31'
Notice: Finished catalog run in 0.11 seconds

root@hiera-2:/etc/puppet/modules/startrek# FACTER_species=romulan puppet apply tests/init.pp 
Notice: Compiled catalog for hiera-2.green.gah in environment production in 1.06 seconds
Notice: janeway commands the voyager
Notice: /Stage[main]/Startrek/Notify[janeway commands the voyager]/message: defined 'message' as 'janeway commands the voyager'
Notice: janeway is always wary of the tal shiar
Notice: /Stage[main]/Startrek/Notify[janeway is always wary of the tal shiar]/message: defined 'message' as 'janeway is always wary of the tal shiar'
Notice: Finished catalog run in 0.11 seconds

root@hiera-2:/etc/puppet/modules/startrek# FACTER_species='' puppet apply tests/init.pp 
Notice: Compiled catalog for hiera-2.green.gah in environment production in 1.07 seconds
Notice: janeway commands the voyager
Notice: /Stage[main]/Startrek/Notify[janeway commands the voyager]/message: defined 'message' as 'janeway commands the voyager'
Notice: janeway is always wary of the 
Notice: /Stage[main]/Startrek/Notify[janeway is always wary of the ]/message: defined 'message' as 'janeway is always wary of the '
Notice: Finished catalog run in 0.12 seconds
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
