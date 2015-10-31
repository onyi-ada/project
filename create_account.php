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
	echo "passwords were equivalent";
	//File put contents removes the need to create/open/append/close the file
	file_put_contents("database.txt", $username . ":" . $p1 . "\r\n", FILE_APPEND);
}
else{
	echo "passwords are not equivalent";
}


?>
