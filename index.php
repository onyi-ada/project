<?php
session_start();

$imgsrc = $_SESSION['gant'];

//Function to recursively remove a directory
function rrmdir($dir)
{
	foreach(glob("{$dir}/*") as $object)
	{
		if(is_dir($object))
		{
			rrmdir($object);
		} else {
			unlink($object);
		}
	}
	rmdir($dir);
}

//Gets current unix time
$time = time();

//File error from uoload
$error = $_SESSION['error'];

//Grabs all the items in the current directory
$items = glob("*",GLOB_BRACE);

//Loop to check how old the temp_data folders are, if older than 1hr (3600 seconds) deletes them
foreach($items as $item)
{
	if(preg_match('/temp_data.*/', $item))
	{
		$creation_time = filemtime($item);

		if($creation_time + 3600 < $time)
		{
			rrmdir($item);
		}
	}
}

print <<<EOT
<head>
<title>Upload Page</title>
<style>
	img {
		width: 600px;
	}
</style>
</head>
<body>
	<h1>Upload an Excel file</h1>
	<form enctype = multipart/form-data method=POST action="upload.php">
		<input type=file value=ChooseFile name=ChooseFile>
		<input type=submit name=Upload>

		<br><br>

		$error

		<br><br>

		<img src=$imgsrc>
	</form>
</body>

EOT;
?>
