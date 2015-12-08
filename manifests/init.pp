class rattic {


  class { 'rattic::apache'       : } ->
  class { 'rattic::packages'     : } ->
  class { 'rattic::mysql'        : } ->
  class { 'rattic::rattic_setup' : } 

}
