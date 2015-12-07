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
<link rel=stylesheet type="text/css" href="StyleSheet2.css">
<title>Project Management</title>
$imghide
</head>

<body>
	<header>
		<h1>Project Manager</h1>
		<ul>
			<li><a href="about.html">About Page</a></li>
			<li><a href="Wiest_RawData.xlsx">Test File</a></li>
		</ul>
	</header>
 

	<form enctype="multipart/form-data" method="POST" action="upload2.php">
    
	    <input type="file" value="ChooseFile" name="ChooseFile">
	    
	    <button type="submit" name="Upload" style="width: 100px; height: 40px;">Generate Gantt</button>
	    
	    <div id="wrapper">
	    	<img src=$imgsrc class=gant>      
	    </div>

	</form>

	<footer>
		<p>
			&copy 2015 Created by: Joy Onyerikwu (Lead), Michael Tillotson, Cullen Vaughn
		</p>
	</footer>

</body>
EOT;
?>
