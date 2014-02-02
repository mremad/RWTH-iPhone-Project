<?php

class SetNicknameHandler extends ActionHandler
{
	public function trigger()
	{	
		// Escape string for protecting against injection.
		$userID = $this->getUserIDIfExists($this->options["username"]);
		$nickname = $this->mysqli->real_escape_string($this->options["nickname"]);
		if ($userID > 0)
		{
			$query = "UPDATE users SET nickname = '$nickname' WHERE ID = $userID LIMIT 1";
			$res = $this->mysqli->query($query);
			if ($res)
				return array("response" => "success");
		}
		return array("response" => "failure");
	}
}


?>