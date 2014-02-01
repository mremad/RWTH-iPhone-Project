<?php

include "config.php";

$files = scandir(CLASS_DIR);
if (!empty($files))
{
	foreach($files as $file)
	{
		$path_parts = pathinfo(CLASS_DIR."/".$file);
		$ext = strtolower($path_parts["extension"]);
		if ($ext == "php")
		{
			$filename = $path_parts["filename"];
			$global_class_dir[$filename] = CLASS_DIR."/";
		}	
	}
}

function __autoload($classname) 
{
  	global $global_class_dir;
  	if (is_array($global_class_dir) && !empty($global_class_dir) && array_key_exists($classname, $global_class_dir))
  	{
    	$filename = $global_class_dir[$classname]. $classname .".php";
    	if (file_exists($filename))
      		include_once($filename);
  	}
}


?>