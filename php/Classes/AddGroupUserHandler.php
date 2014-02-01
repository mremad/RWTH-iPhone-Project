<?php

class AddGroupUserHandler extends GroupHandler
{
	public function trigger()
	{	
		$userID = $this->getUserIDIfExists($this->options["username"]);
		$groupID = $this->getGroupIDIfExists($this->options["groupID"]);
		if ($userID > 0 && $groupID > 0)
		{
			$userAlreadyInGroup = $this->isUserInGroup($username, $groupID);
			if ( !$userAlreadyInGroup)
			{	
				$query = "INSERT INTO groupusers (groupID, userID) VALUES ($groupID, $userID)";
				$res = $this->mysqli->query($query);
				
				return array("response" => "success");
			}
			return array("response" => "user already in group");
		}
		return array("response" => "failure");
	}
}


?>