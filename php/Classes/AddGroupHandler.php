<?php

class AddGroupHandler extends GroupHandler
{
	public function trigger()
	{	
		$userID = $this->getUserIDIfExists($this->options["username"]);
		$groupname = $this->mysqli->real_escape_string($this->options["groupname"]);
		
		if ($userID > 0 && $groupname)
		{
			$query = "INSERT INTO groups (ownerID, groupname) VALUES ($userID, '$groupname')";
			$res = $this->mysqli->query($query);
			if (!$res)
			{
				return array("query '$query' has errors!");
			}
			$groupID = $this->mysqli->insert_id;
			
			$query = "INSERT INTO groupusers (groupID, userID, accepted) VALUES ($groupID, $userID, 1)";
			$res = $this->mysqli->query($query);
			if (!$res)
			{
				return array("query '$query' has errors!");
			}
			
			return array("response" => "success", "groupID" => $groupID);
		}
		else if (!$groupname)
		{
			return array("response" => "groupname is missing!");
		}
		else
		{
			return array("response" => "user ".$this->options["username"]." does not exist!");
		}
	}
}


?>