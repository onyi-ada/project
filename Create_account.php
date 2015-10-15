<?php
#crypt.ph

//declare variables from Create_account.html
$usrName = $_POST('usrName');
$email = $_POST('email');
$password = $_POST('password');
$password2 = $_POST('password2');

//test to see if both passwords that the user types in are the same
if(crypt($password) == crypt($password2)){
$handle = fopen('database.txt', 'a');                //open text file to append data
fwrite($handle, $usrName. ":" $password. "\n");      // write the usrname and password to file
fclose($handle);                                     //close file

$readin = file('database.txt');                     //read database.txt file

//go through file and display each line
foreach($readin as $var){
	echo $var. "/n";
	
}

}else{
	echo 'please re-enter your password';
}


?>
