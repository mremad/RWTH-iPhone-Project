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
	// Users table
	$query = "CREATE TABLE IF NOT EXISTS users (ID BIGINT UNSIGNED NOT NULL AUTO_INCREMENT, username VARCHAR(64) NOT NULL, PRIMARY KEY (ID))";
	$res = $mysqli->query($query);
	
	// Groups table
	$query = "CREATE TABLE IF NOT EXISTS groups (ID BIGINT UNSIGNED NOT NULL AUTO_INCREMENT, ownerID BIGINT UNSIGNED NOT NULL, PRIMARY KEY (ID))";
	$res = $mysqli->query($query);
	
	
	// Group users table
	$query = "CREATE TABLE IF NOT EXISTS groupusers (groupID BIGINT UNSIGNED NOT NULL, userID BIGINT UNSIGNED NOT NULL)";
	$res = $mysqli->query($query);
}





?>