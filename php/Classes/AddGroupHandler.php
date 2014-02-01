<?php

class AddGroupHandler extends GroupHandler
{
	public function trigger()
	{	
		$userID = $this->getUserIDIfExists($this->options["username"]);
		if ($userID > 0)
		{
			$query = "INSERT INTO groups (ownerID) VALUES ($userID)";
			$res = $this->mysqli->query($query);
			$groupID = $this->mysqli->insert_id;
			
			$query = "INSERT INTO groupusers (groupID, userID) VALUES ($groupID, $userID)";
			$res = $this->mysqli->query($query);
			
			return array("response" => "success", "groupID" => $groupID);
		}
	}
}


?>