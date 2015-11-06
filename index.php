<?php
session_start();

$imgsrc = $_SESSION['gant'];

if(!file_exists($imgsrc))
{
	$imghide = "<style> img { display: none; } </style>";
} else
{
	$imghide = "";
}

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
<link rel=stylesheet type="text/css" href="StyleSheet.css">
<title>Project Management</title>
$imghide
</head>
<body>
	<h1>Project Manager</h1>
	<p>
		<a href="http://localhost/project/About.html">About</a>
		<a href="Wiest_RawData.xlsx">Click to download test file</a>
	</p>
 

	<form enctype="multipart/form-data" method="POST" action="upload.php">
    
	    <input type="file" value="ChooseFile" name="ChooseFile">
	    
	    <button type="submit" name="Upload" style="width: 100px; height: 40px;">Upload</button>
	    
	    <div id="wrapper">
	    	<img src=$imgsrc class=gant>      
	    </div>

	</form>
</body>
EOT;
?>
