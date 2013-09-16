# == Class: startrek
#
# A Proof of Concept of Data in Modules
#
class startrek {

   $captain = lookup('captain')
   $ship = lookup('starship')

   notify {"${captain} commands the ${ship['name']}": }

   $secret_group = lookup('secret_group')

   notify {"${captain} is always wary of the ${secret_group}": }



}
