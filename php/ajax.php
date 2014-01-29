<?php

define ('DB_HOST', 'localhost');
define ('DB_DATABASE', 'skedify');
define ('DB_USER', 'skedifyAdmin');
define ('DB_PASSWORD', 'skedify');



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
		return array("response" => "success");
	}
		
}

class LoginHandler extends ActionHandler
{
	public function trigger()
	{	
		// Escape string for protecting against injection.
		$username = $this->mysqli->real_escape_string($this->options["username"]);
		if ($username && !$this->userExists())
		{	
			$query = "INSERT INTO users (username) VALUES ('$username')";
			$res = $this->mysqli->query($query);
			
			return array("response" => "success");
		}
		return array("response" => "failure");
		
	}
	private function userExists()
	{
		// Check if user already exists.
		
		// Escape string for protecting against injection.
		$username = $this->mysqli->real_escape_string($this->options["username"]);
		$query = "SELECT ID FROM users WHERE username = '$username' LIMIT 1";
		$res = $this->mysqli->query($query);
		if ($res)
		{
			$res->data_seek(0);
			while ($row = $res->fetch_assoc()) 
			{
				return true;
			}
			return false;
		}
	}
}

class AjaxHandler
{
  	/*
    	Class for handling ajax and printing results in JSON format
  	*/
	public function __construct()
  	{
		header("Cache-Control: no-cache");
		header('Content-type: application/json');
	
		if ($_SERVER['REQUEST_METHOD'] === 'POST')
		{
			$this->actionHandler = $_POST["action"];
			$this->options = $_POST;
			unset($this->options["action"]);
		}
		else if ($_SERVER['REQUEST_METHOD'] === 'GET')
		{
			$this->actionHandler = $_GET["action"];
			$this->options = $_GET;
			unset($this->options["action"]);
		}
		else
			die();
		echo $this->getJSONData();
		// Make sure that nothing else gets evaluated after this method.
		die();
  	}
	public function getJSONData()
  	{   
		$class = $this->actionHandler."Handler";
    	if (class_exists($class) && is_subclass_of($class, "ActionHandler")) // FIXME: exception handling!!
    	{
      		$obj = new $class($this->options);
			// Trigger the action.
        	$data = $obj->trigger();
        	if (!empty($data)) // Return json data if not empty
          		return json_encode($data);
    	}
		return json_encode(array());
	}
}

$ajaxHandler = new AjaxHandler;

?>