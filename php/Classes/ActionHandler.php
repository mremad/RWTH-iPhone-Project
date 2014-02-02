<?php


/*

Database access example:

$res = $>mysqli->query($query);

//echo "Reverse order...\n";
for ($row_no = $res->num_rows - 1; $row_no >= 0; $row_no--) {
$res->data_seek($row_no);
$row = $res->fetch_assoc();
// process each row...
echo " id = " . $row['id'] . "\n";
}

if ($res)
{
	$res->data_seek(0);
	while ($row = $res->fetch_assoc()) 
	{
		// process each row...
		echo " id = " . $row['id'] . "\n";
	}
}

*/

class ActionHandler
{
	protected $options;
	protected $mysqli;
	public function __construct($options = array())
	{
		$this->options = $options;
		
		$this->mysqli = new mysqli(DB_HOST, DB_USER, DB_PASSWORD, DB_DATABASE);
		if ($this->mysqli->connect_errno) 
		{
			echo "Failed to connect to MySQL: (" . $this->mysqli->connect_errno . ") " . $this->mysqli->connect_error;
			die();
		}
	}
	
	public function trigger()
	{
		return array("response" => "action not implemented", "sent data" => $this->options);
	}
	
	protected function getUserIDIfExists($username)
	{
		if (!$username)
			return 0;
		
		
		// Check if user already exists.
		// Escape string for protecting against injection.
		$username = $this->mysqli->real_escape_string($username);
		$query = "SELECT ID FROM users WHERE username = '$username' LIMIT 1";
		$res = $this->mysqli->query($query);
		if ($res)
		{
			$res->data_seek(0);
			while ($row = $res->fetch_assoc()) 
			{
				return $row["ID"];
			}
		}
		return 0;
	}
	
	protected function getUsername($userID)
	{
		if ($userID <= 0)
			return 0;
		$query = "SELECT username FROM users WHERE ID = $userID LIMIT 1";
		$res = $this->mysqli->query($query);
		if ($res)
		{
			$res->data_seek(0);
			while ($row = $res->fetch_assoc()) 
			{
				return $row["username"];
			}
		}
		return null;
	}
	
	protected function getNickname($userID)
	{
		if ($userID <= 0)
			return 0;
		$query = "SELECT nickname FROM users WHERE ID = $userID LIMIT 1";
		$res = $this->mysqli->query($query);
		if ($res)
		{
			$res->data_seek(0);
			while ($row = $res->fetch_assoc()) 
			{
				return $row["nickname"];
			}
		}
		return null;
	}
		
}




?>