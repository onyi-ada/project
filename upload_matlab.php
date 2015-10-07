<?php

if(isset($_POST['Upload']))
{
	if(isset($_FILES['ChooseFile']))
	{
		$file = basename($_FILES['ChooseFile']['name']);

		if(preg_match('/\s/', $file))
		{
			$file = preg_replace('/\s/', '', $file);
		}

		move_uploaded_file($_FILES['ChooseFile']['tmp_name'], $file);
	}

	exec("/Applications/MATLAB_R2015b.app/bin/./matlab -c license.lic.txt -r 'DominantConstraints Wiest_RawData.xlsx; exit;'");
}


print<<<EOT
<head>
<title>Upload Page</title>
</head>

<body>

	<h1>Upload an Excel file</h1>



	<form enctype = multipart/form-data method=POST action="index.php">
		<input type=file value=ChooseFile name=ChooseFile>
		<input type=submit name=Upload>
	</form>
</body>
EOT;
?>
