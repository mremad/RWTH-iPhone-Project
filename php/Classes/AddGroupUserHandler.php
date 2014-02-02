<?php

class AddGroupUserHandler extends GroupHandler
{
	public function trigger()
	{	
		$userID = $this->getUserIDIfExists($this->options["username"]);
		$adderID = $this->getUserIDIfExists($this->options["adder"]);
		$groupID = $this->getGroupIDIfExists($this->options["groupID"]);
		if ($userID > 0 && $groupID > 0 && $adderID > 0)
		{
			$userAlreadyInGroup = $this->isUserInGroup($username, $groupID);
			if ( !$userAlreadyInGroup)
			{	
				$query = "INSERT INTO groupusers (groupID, userID, adderID) VALUES ($groupID, $userID, $adderID)";
				$res = $this->mysqli->query($query);
				
				return array("response" => "success");
			}
			return array("response" => "user already in group");
		}
		return array("response" => "failure");
	}
}


?>