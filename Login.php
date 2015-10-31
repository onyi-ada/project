<?php
#crypt.ph
session_start();

//Checks to see if the Login button was pressed
if(isset($_POST['Login']))
{
	//declare variables from projectManagement.html
	$username = $_POST['usrName'];
	$password = $_POST['password'];
	
	// encrypts password and sets database file to variable
	$p1 = crypt($password, "salt");
	$criteria = fopen( "database.txt", "r");
	
	//matches the password and username until the end of file
	while (! feof($criteria)) {
	echo "hello";
	$line = fgets($criteria);
	
	preg_match("~(.*)(:)(.*)~" , $line , $matches);
	
	if ($username == $matches[1]){
		print_r($matches) ;
		if ($p1 == $matches[3]){
			
			//header('Location: http://localhost/project/Application.html');
		}
		
		
	}
	
	}
	fclose($criteria);
}
	
	echo "The username and/or password was not found.";
?>
