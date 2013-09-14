# == Class: startrek
#
# A Proof of Concept of Data in Modules
#
class startrek {

   $captain = lookup('captain')
   $ship = lookup('starship')

   notify {"${captain} commands the ${ship['name']}": }



}
