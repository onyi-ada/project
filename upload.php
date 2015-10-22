<?php
session_start();
$folder = "temp_data";

//Checks to see if the upload button was pressed
if(isset($_POST['Upload']))
{
	//Checks to see if there was a chosen file
	if(isset($_FILES['ChooseFile']))
	{
		$file = basename($_FILES['ChooseFile']['name']);

		//Checks to see if the file is a valid excel file
		if(preg_match('/.*xls/', $file) || preg_match('/.*xlsx/', $file))
		{
			//Checks for spaces
			if(preg_match('/\s/', $file))
			{
				//Removes the spaces
				$file = preg_replace('/\s/', '', $file);
			}

			//Checks for the temp_data folder
			if(is_dir($folder))
			{
				$i = 1;
				//If temp_data folder exists, iterates until finds new folder
				while(is_dir($folder . $i))
				{
					$i++;
				}
				//Concatenates a number at the end of temp_data
				$curr_dir = $folder . $i;

				//Creates the new folder
				mkdir($curr_dir);

			} else
			{
				$curr_dir = $folder;

				//Creates the temp_data folder
				mkdir($curr_dir);
			}

			//Uploads the file
			move_uploaded_file($_FILES['ChooseFile']['tmp_name'], $curr_dir . '/' . $file);

			//Runs Matlab
			$exec_string = "/Applications/MATLAB_R2015b.app/bin/./matlab -nosplash -c /Applications/MATLAB_R2015b.app/license.lic.txt -r 'DominantConstraints" . " $curr_dir/$file" . " $curr_dir" . "; exit;'"; 
			exec($exec_string);
			
			$_SESSION['gant'] = $curr_dir . "/gant.png";

		} else
		{
			//If uploaded file is invalid, reports an error
			$_SESSION['error'] = "Not a valid file!";
		}
	}

	//Sends the browser back to the upload page
	header('Location:index.php?success=true');
}

//Print the file name for testing purposes
//echo basename($_FILES['ChooseFile']['name']);

?>
