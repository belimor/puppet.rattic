class rattic {

#include ::rattic::apache 
#include ::rattic::packages 
#include ::rattic::mysql 
#include ::rattic::rattic_setup

  class { 'rattic::apache'       : } ->
  class { 'rattic::packages'     : } ->
  class { 'rattic::mysql'        : } ->
  class { 'rattic::rattic_setup' : } 

}
