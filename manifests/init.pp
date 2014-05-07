class rattic {

	include rattic::apache ->
	include rattic::packages ->
	include rattic::mysql ->
	include rattic::rattic_setup 
	

}

