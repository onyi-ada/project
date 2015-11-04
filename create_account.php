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


//declare variables from Create_account.html
$username = $_POST['usrName'];
$email = $_POST['email'];
$password = $_POST['password'];
$password2 = $_POST['password2'];
//Added salt so they will be the same
$p1 = crypt($password, "salt");
$p2 = crypt($password2, "salt");
if($p1 == $p2)
{
	//echo "Your passwords are equivalent";
	echo "<p align=center><font size=5>(Your passwords are equivalent)</font> </p> ";
	echo "\n\n\n";
	echo "<p align=center><font size=5>(Go back to login and use your new username and password to access the site)</font> </p> ";
	
	//File put contents removes the need to create/open/append/close the file
	file_put_contents("database.txt", $username . ":" . $p1 . "\r\n", FILE_APPEND);
}
else{
	echo "<p align=center><font size=5>(Your passwords are not equivalent)</font> </p> ";
}


?>

</body>
</html>
