<html>
<head>

<link rel=stylesheet type="text/css" href="StyleSheet.css">

<title>Untitled</title>
<style>

div {
    background-color: light blue;
    width: 300px;
	height: 400px;
    padding: 25px;
    border: 40px  black;
    margin: auto;
}

body {
    background-image: url("http://freeppt.net/background/Sales_Presentation_Template.jpg");
    background-repeat: no-repeat;
	background-size: 1600px 750px;
	}
	

</style>
</head>

<body>
<h1><font size=7 ><center>Project Manager</center></font></h1>
<a href = "http://localhost/project/Login.html"
>return to login</a></font>


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
		
	$line = fgets($criteria);
	
	preg_match("~(.*)(:)(.*)~" , $line , $matches);
	
	if ($username == $matches[1]){
		
		if ($p1 == trim($matches[3])){
			
			header('Location: http://localhost/project/index.php');
		}
		
		
	}
	
	}
	fclose($criteria);
}
	
	
	echo "<p align=center><font size=5>(The username and/or password was not found.)</font> </p> ";
?>



</body>
</html>
