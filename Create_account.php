<?php
#crypt.ph

//declare variables from Create_account.html
//POST uses square brackets not parenthesis
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
	file_put_contents("database.txt", $username . ":" . $p1, FILE_APPEND);
}

// //test to see if both passwords that the user types in are the same
// if(crypt($password) == crypt($password2)){
// $handle = fopen('database.txt', 'a');                //open text file to append data
// fwrite($handle, $usrName. ":" $password. "\n");      // write the usrname and password to file
// fclose($handle);                                     //close file

// $readin = file('database.txt');                     //read database.txt file

// //go through file and display each line
// foreach($readin as $var){
// 	echo $var. "/n";
	
// }

// }else{
// 	echo 'please re-enter your password';
// }


?>
