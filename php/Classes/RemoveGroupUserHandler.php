<?php

class RemoveGroupUserHandler extends GroupHandler
{
	public function trigger()
	{	
		$userID = $this->getUserIDIfExists($this->options["username"]);
		$groupID = $this->getGroupIDIfExists($this->options["groupID"]);
		if ($userID > 0 && $groupID > 0)
		{
			$userAlreadyInGroup = $this->isUserInGroup($username, $groupID);
			if ($userAlreadyInGroup)
			{	
				$query = "DELETE FROM groupusers WHERE userID = $userID AND groupID = $groupID";
				$res = $this->mysqli->query($query);
				
				return array("response" => "success");
			}
			return array("response" => "user not in group");
		}
		return array("response" => "failure");
	}
}


?>