# == Class: startrek
#
# A Proof of Concept of Data in Modules
#
class startrek {

   if $cringe {
     $akward = lookup('akward_character')
     notify {"${akward} is always screwing it up": }
   }
    


   $captain = lookup('captain')
   $ship = lookup('starship')

   notify {"${captain} commands the ${ship['name']}": }

   $secret_group = lookup('secret_group')

   notify {"${captain} is always wary of the ${secret_group}": }



}
