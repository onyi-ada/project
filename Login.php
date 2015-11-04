
<html>
<head>

<link rel=stylesheet type="text/css" href="StyleSheet.css">

<title>Untitled</title>
<style>
#wrapper {
    width: 300px;
    border: 1px solid black;
    overflow: auto; /* so the size of the wrapper is alway the size of the longes
    float: left;t content */
}
#first {
    width: 298px;
	height:200px;
    border: 1px solid black;
}
#second {
    border: 1px solid black;
	height: 298px;
    margin: 0 0 0 350px; 
}
a {
    width:200px;
    display:inline-block;
    text-align:right;
}
body {
    background-image: url("http://freeppt.net/background/Sales_Presentation_Template.jpg");
    background-repeat: no-repeat;
	background-size: 1600px 750px;
	}
	
h1 {
    color: gray;
}
.right {
    text-align: right;
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
