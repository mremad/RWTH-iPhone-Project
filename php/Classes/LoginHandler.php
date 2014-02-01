<?php

class LoginHandler extends ActionHandler
{
	public function trigger()
	{	
		// Escape string for protecting against injection.
		$username = $this->mysqli->real_escape_string($this->options["username"]);
		$userExists = (bool)$this->getUserIDIfExists($this->options["username"]);
		if ($username && !$userExists)
		{	
			$query = "INSERT INTO users (username) VALUES ('$username')";
			$res = $this->mysqli->query($query);
			
			return array("response" => "success");
		}
		else if ($userExists)
			return array("response" => "user '".$this->options["username"]."' exists");
		return array("response" => "failure");
		
	}
	
}


?>