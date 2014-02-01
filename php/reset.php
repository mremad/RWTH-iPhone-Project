<?php

include "config.php";

$mysqli = new mysqli(DB_HOST, DB_USER, DB_PASSWORD, DB_DATABASE);
if ($mysqli->connect_errno) 
{
	echo "Failed to connect to MySQL: (" . $mysqli->connect_errno . ") " . $mysqli->connect_error;
	die();
}
else
{
	$query = "TRUNCATE users";
	$res = $mysqli->query($query);
	$query = "TRUNCATE groupusers";
	$res = $mysqli->query($query);
	$query = "TRUNCATE groups";
	$res = $mysqli->query($query);
}





?>