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
	background-size: 1600px 750px;
    background-repeat: no-repeat;
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

<p align="left" size= 7><a
 href="http://localhost/project/About.html";
 >About</a></p>



<center>
<form enctype="multipart/form-data" method="POST" action="upload.php">
    <input type="file" value="ChooseFile" name="ChooseFile">
    <button type="submit" name="Upload" style="width: 100px; height: 40px;">Upload</button>

    <div id="wrapper">
        <div id="first">
        </div>
    	
            <button type="button big-btn" style="width: 100px; height: 50px;">Calculate</button>
        
    </div></center>
	<img src= "http://www.d.umn.edu/~gshute/softeng/new/process/images/concurrent.png"
style="width:304px;height:130px;">
</form>
</body>
EOT;
?>
